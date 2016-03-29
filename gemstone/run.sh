################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################ 

export GS_HOME="${SMALLTALK_CI_BUILD}/GsDevKit_home"
local GS_STONE_NAME="travis"
local GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"
local GS_DEVKIT_BRANCH="master"
local PHARO_IMAGE_FILE="Pharo-3.0.image"
local PHARO_CHANGES_FILE="Pharo-3.0.changes"

################################################################################
# Handle GemStone-specific options.
################################################################################
gemstone::parse_options() {
  while :
  do
    case "${1:-}" in
      --gs-branch)
        GS_DEVKIT_BRANCH="${2:-}"
        shift 2
        ;;
      --gs-repository)
        GS_DEVKIT_DOWNLOAD="${2:-}"
        shift 2
        ;;
      --gs-stone)
        GS_STONE_NAME="${2:-}"
        shift 2
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
}

################################################################################
# Clone the GsDevKit_home project.
################################################################################
gemstone::prepare_gsdevkit_home() {
  travis_fold start clone_gsdevkit "Cloning GsDevKit..."
    timer_start

    pushd "${SMALLTALK_CI_BUILD}" || exit 1
      git clone "${GS_DEVKIT_DOWNLOAD}" || exit 1
      cd "${GS_HOME}" || exit 1
      git checkout "${GS_DEVKIT_BRANCH}" || exit 1

      # pre-clone /sys/local, so that travis can skip backups
      $GS_HOME/bin/private/clone_sys_local || exit 1
      # arrange to skip backups
      cp $GS_HOME/tests/sys/local/client/tode-scripts/* $GS_HOME/sys/local/client/tode-scripts || exit 1

      # Operating system setup already performed
      touch $GS_HOME/bin/.gsdevkitSysSetup || exit 1
    popd || exit 1

    export GS_TRAVIS=true # install special key files for running GemStone on Travis hosts

    timer_finish
  travis_fold end clone_gsdevkit
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

  travis_fold start install_server "Installing server..."
    timer_start

    $GS_HOME/bin/installServer || print_error_and_exit "installServer failed."

    timer_finish
  travis_fold end install_server

  if [ "${GS_TRAVIS_CACHE_ENABLED}" = "false" ] ; then
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

    if [ "${GS_TRAVIS_CACHE_ENABLED}" = "false" ] ; then
      $GS_HOME/bin/createStone "${GS_STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
    else
      if ! is_file "$gemstone_cached_extent_file"; then
        $GS_HOME/bin/createStone "${GS_STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
        cp "$GS_HOME/server/stones/${GS_STONE_NAME}/snapshots/extent0.tode.dbf" "$gemstone_cached_extent_file"
      else
        $GS_HOME/bin/createStone -t "$gemstone_cached_extent_file" "${GS_STONE_NAME}" "${gemstone_version}" || print_error_and_exit "createStone failed."
      fi
  
      if ! is_file "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image"; then
        cp $GS_HOME/shared/pharo/gsDevKitCommandLine.* "${SMALLTALK_CI_CACHE}/gemstone/pharo/"
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

  travis_fold start load_and_test "Loading and testing project..."
    timer_start

    $GS_HOME/bin/devKitCommandLine serverDoIt "${GS_STONE_NAME}" << EOF || status=$?
      Metacello new
        baseline: 'SmalltalkCI';
        repository: 'filetree://${SMALLTALK_CI_HOME}/repository';
        load: 'Core'.
      (Smalltalk at: #SmalltalkCI) runCIFor: '${config_project_home}/${config_ston}'.
      System commitTransaction.
EOF

    $GS_HOME/bin/stopStone -b "${GS_STONE_NAME}" || print_error_and_exit "stopStone failed."

    timer_finish
  travis_fold end load_and_test

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

  # Temporary fix for https://github.com/hpi-swa/smalltalkCI/issues/68
  case "$(uname -s)" in
    "Darwin")
      sudo sysctl -w kern.sysv.shmall=524288
      ;;
  esac

  # To bypass cached behavior for local build, export GS_TRAVIS_CACHE_ENABLED
  # before calling run.sh
  if [ "${GS_TRAVIS_CACHE_ENABLED}x" = "x" ]; then
    GS_TRAVIS_CACHE_ENABLED="true"
    if [ "${CASHER_DIR}x" = "x" ] ; then
      if [ "$TRAVIS" = "true" ] ; then
        GS_TRAVIS_CACHE_ENABLED="false"
      fi
    fi
  fi
  export GS_TRAVIS_CACHE_ENABLED

  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${config_smalltalk}"
  gemstone::load_and_test_project || exit_status=$?

  return "${exit_status}"
}
