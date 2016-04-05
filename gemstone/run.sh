################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################ 

local DEFAULT_GS_HOME="${SMALLTALK_CI_BUILD}/GsDevKit_home"
local DEFAULT_DEVKIT_BRANCH="master"
local USE_DEFAULT_HOME="true"
local STONE_NAME="travis"
local DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"
local DEVKIT_BRANCH
local PHARO_IMAGE_FILE="Pharo-3.0.image"
local PHARO_CHANGES_FILE="Pharo-3.0.changes"

################################################################################
# Handle GemStone-specific options.
################################################################################
gemstone::parse_options() {

  GS_HOME="$DEFAULT_GS_HOME"

  if [ "${GSCI_DEVKIT_BRANCH-}x" = "x" ] ; then
    DEVKIT_BRANCH="${DEFAULT_DEVKIT_BRANCH}"
  else
    DEVKIT_BRANCH="${GSCI_DEVKIT_BRANCH}"
  fi

  while :
  do
    case "${1:-}" in
      --gs-HOME=*)
        GS_HOME="${1#*=}"
        shift
        USE_DEFAULT_HOME="false"
        ;;
      --gs-DEVKIT_BRANCH=*)
        DEVKIT_BRANCH="${1#*=}"
        shift
        ;;
      --gs-*)
        print_error_and_exit "Unknown GemStone-specific option: $1"
        ;;
      "")
        break
        ;;
      *)
        shift
        ;;
    esac
  done

  export GS_HOME
}

################################################################################
# Clone the GsDevKit_home project.
################################################################################
gemstone::prepare_gsdevkit_home() {

  if [ "$USE_DEFAULT_HOME" = "true" ] ; then
    travis_fold start clone_gsdevkit "Cloning GsDevKit..."
      timer_start

      pushd "${SMALLTALK_CI_BUILD}" || print_error_and_exit "pushd failed."
        git clone "${DEVKIT_DOWNLOAD}" || print_error_and_exit "git clone failed."
        cd "${GS_HOME}" || print_error_and_exit "cd failed."
        git checkout "${DEVKIT_BRANCH}" || print_error_and_exit "git checkout failed."

        # pre-clone /sys/local, so that travis can skip backups
        $GS_HOME/bin/private/clone_sys_local || print_error_and_exit "clone_sys_local failed."
        # arrange to skip backups
        cp $GS_HOME/tests/sys/local/client/tode-scripts/* $GS_HOME/sys/local/client/tode-scripts || print_error_and_exit "cp failed."

        # Operating system setup already performed
        touch $GS_HOME/bin/.gsdevkitSysSetup || print_error_and_exit "touch failed."

	# Make sure the GsDevKit_home is using $SMALLTALK_CI_HOME in $GS_HOME/shared/repos
	ln -s ${SMALLTALK_CI_HOME} $GS_HOME/shared/repos/smalltalkCI || print_error_and_exit "ln -s failed."

	ls -altr  $GS_HOME/shared/repos

      popd || print_error_and_exit "popd failed."

      timer_finish
    travis_fold end clone_gsdevkit

    export GS_TRAVIS=true # install special key files for running GemStone on Travis hosts

  else

    print_info "Using existing GsDevKit_home clone: \$GS_HOME=$GS_HOME"

  fi

}

################################################################################
# Create a GemStone stone.
# Arguments:
#   config_smalltalk
################################################################################
gemstone::prepare_stone() {
  local gemstone_version

  gemstone_version="$(echo $1 | cut -f2 -d-)"

  local gemstone_cached_extent_file="${SMALLTALK_CI_CACHE}/gemstone/extents/${gemstone_version}_extent0.tode.dbf"

  if [ "$USE_DEFAULT_HOME" = "true" ] ; then
    travis_fold start install_server "Installing server..."
      timer_start

      $GS_HOME/bin/installServer || print_error_and_exit "installServer failed."

      # Temporary fix for https://github.com/hpi-swa/smalltalkCI/issues/68
      case "$(uname -s)" in
        "Darwin")
          sudo sysctl -w kern.sysv.shmall=524288
          ;;
      esac

      timer_finish
    travis_fold end install_server
  fi

  if ! is_dir "${SMALLTALK_CI_CACHE}/gemstone"; then
    print_info "Creating GemStone extent cache..." 
    mkdir "${SMALLTALK_CI_CACHE}/gemstone"
    if ! is_dir "${SMALLTALK_CI_CACHE}/gemstone/extents"; then
      mkdir "${SMALLTALK_CI_CACHE}/gemstone/extents"
    fi
    if ! is_dir "${SMALLTALK_CI_CACHE}/gemstone/pharo"; then
      mkdir "${SMALLTALK_CI_CACHE}/gemstone/pharo"
    fi
  fi
  

  if [ "${TRAVIS_CACHE_ENABLED:-}" = "false" ] ||
       [ "$GS_HOME" != "$DEFAULT_GS_HOME" ] ; then
    print_info "Travis dependency cache not being used"
  else
    travis_fold start prepare_cache "Preparing Travis caches..."
      timer_start
      if ! is_dir "${SMALLTALK_CI_VMS}/Pharo-3.0"; then
        mkdir "${SMALLTALK_CI_VMS}/Pharo-3.0"
        print_info "Downloading Pharo-3.0 vm to cache" 
        pushd "${SMALLTALK_CI_VMS}/Pharo-3.0" > /dev/null
          pharo_zeroconf="$(download_file "get.pharo.org/vm30")" || print_error_and_exit "Pharo-3.0 vm download failed."
          bash -c "${pharo_zeroconf}"  || print_error_and_exit "Pharo-3.0 vm download failed."
        popd > /dev/null
      fi
  
      if ! is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}"; then
        print_info "Downloading Pharo-3.0 image to cache..." 
        pushd ${SMALLTALK_CI_CACHE} > /dev/null
          pharo_zeroconf="$(download_file "get.pharo.org/30")" || print_error_and_exit "Pharo-3.0 image download failed."
          bash -c "${pharo_zeroconf}"  || print_error_and_exit "Pharo-3.0 image download failed."
          mv "Pharo.image" "${PHARO_IMAGE_FILE}"
          mv "Pharo.changes" "${PHARO_CHANGES_FILE}"
        popd > /dev/null
      fi
  
      if is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}"; then
        if is_file "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image"; then
          print_info "Utilizing cached gsDevKitCommandLine image..." 
          cp "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}" $GS_HOME/shared/pharo/Pharo.image
          cp "${SMALLTALK_CI_CACHE}/${PHARO_CHANGES_FILE}" $GS_HOME/shared/pharo/Pharo.changes
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo" $GS_HOME/shared/pharo/pharo
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo-ui" $GS_HOME/shared/pharo/pharo-ui
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo-vm" $GS_HOME/shared/pharo/pharo-vm
          cp "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image" $GS_HOME/shared/pharo/
          cp "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.changes" $GS_HOME/shared/pharo/
        fi
      fi
  
      timer_finish
    travis_fold end prepare_cache
  fi

  travis_fold start create_stone "Creating stone..."
    timer_start

    if [ -e "$GS_HOME/bin/.smalltalkCI_create_arg_supported" ] ; then
      config_stone_create_arg="-z ${config_project_home}/${config_ston}"
    fi

    if [ "${TRAVIS_CACHE_ENABLED:-}" = "false" ] ; then
      $GS_HOME/bin/createStone ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
    else
      if ! is_file "$gemstone_cached_extent_file"; then
        $GS_HOME/bin/createStone ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
        cp "$GS_HOME/server/stones/${STONE_NAME}/snapshots/extent0.tode.dbf" $gemstone_cached_extent_file || print_error_and_exit "copy extent0.tode.dbf to travis cache failed."
      else
        $GS_HOME/bin/createStone -t "$gemstone_cached_extent_file" ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
      fi
  
      if ! is_file "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image"; then
        cp $GS_HOME/shared/pharo/gsDevKitCommandLine.* "${SMALLTALK_CI_CACHE}/gemstone/pharo/" || print_error_and_exit "copy gsDevKitCommandLine.image to travis cache failed."
      fi
    fi

    timer_finish
  travis_fold end create_stone

}

################################################################################
# Load project into GemStone stone and run tests.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
# Returns:
#   Status code of project loading
################################################################################
gemstone::load_and_test_project() {
  local status=0

  travis_fold start load_server_project "Loading server project..."
    timer_start

    $GS_HOME/bin/devKitCommandLine serverDoIt "${STONE_NAME}" << EOF || status=$?
      Metacello new
        baseline: 'SmalltalkCI';
        repository: 'filetree://${SMALLTALK_CI_HOME}/repository';
        load: 'Core'.
      System commitTransaction.
      (Smalltalk at: #SmalltalkCI) loadCIFor: '${config_project_home}/${config_ston}'.
      System commitTransaction.
EOF

    timer_finish

  travis_fold end load_server_project

  if [ $status -ne 0 ] ; then
    print_error_and_exit "Failed to load project."
  fi

    # this is where the client load is located ... need to do the print_reults() of stone --- probably should be in separate fold

  travis_fold start test_server_project "Testing server project..."
    timer_start

    $GS_HOME/bin/devKitCommandLine serverDoIt "${STONE_NAME}" << EOF || status=$?
      (Smalltalk at: #SmalltalkCI) testCIFor: '${config_project_home}/${config_ston}'.
      System commitTransaction.
EOF

    timer_finish
  travis_fold end test_server_project

    # this is where the client test is located ... need to do the print_reults() of stone  --- probably should be in separate fold

  travis_fold start stop_stone

    $GS_HOME/bin/stopStone -b "${STONE_NAME}" || print_error_and_exit "stopStone failed."

  travis_fold end stop_stone

  return "${status}"
}

################################################################################
# Main entry point for GemStone builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local exit_status=0

  gemstone::parse_options "$@"

  # To bypass cached behavior for local build, export TRAVIS_CACHE_ENABLED
  # before calling run.sh
  if is_empty "${TRAVIS_CACHE_ENABLED:-}"; then
    TRAVIS_CACHE_ENABLED="true"
    if is_empty "${CASHER_DIR:-}"; then
      if is_travis_build; then
        TRAVIS_CACHE_ENABLED="false"
      fi
    fi
  fi
  export TRAVIS_CACHE_ENABLED

  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${config_smalltalk}"
  gemstone::load_and_test_project || exit_status=$?

  return "${exit_status}"
}
