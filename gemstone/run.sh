################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

local STONE_NAME="smalltalkci"
local SUPERDOIT_BRANCH=v3.1
local SUPERDOIT_DOWNLOAD=git@github.com:dalehenrich/smalltalkCI.git
local SUPERDOIT_DOWNLOAD=https://github.com/dalehenrich/superDoit.git
local GSDEVKIT_STONES_BRANCH=v1.1
local GSDEVKIT_STONES_DOWNLOAD=git@github.com:GsDevKit/GsDevKit_stones.git
local GSDEVKIT_STONES_DOWNLOAD=https://github.com/GsDevKit/GsDevKit_stones.git
local STONES_REGISTRY_NAME=smalltalkCI_run

################################################################################
# Clone the superDoit project, install GemStone 3.6.5.
################################################################################
gemstone::prepare_superDoit() {
	fold_start clone_superDoit "Cloning superDoit..."
		pushd "${SMALLTALK_CI_BUILD}"
			git clone -b "${SUPERDOIT_BRANCH}" --depth 1 "${SUPERDOIT_DOWNLOAD}"
			export PATH="`pwd`/superDoit/bin:$PATH"
			fold_start install_superDoit_gemstone "Downloading GemStone for superDoit..."
				install.sh
				versionReport.solo
			fold_end install_superDoit_gemstone
		popd
	fold_end clone_superDoit
}

################################################################################
# Clone the GsDevKit_stones project
################################################################################
gemstone::prepare_gsdevkit_stones() {
	fold_start clone_gsdevkit_stones "Cloning GsDevKit_stones..."
		pushd "${SMALLTALK_CI_BUILD}"
			git clone -b "${GSDEVKIT_STONES_BRANCH}" --depth 1 "${GSDEVKIT_STONES_DOWNLOAD}"
			export PATH="`pwd`/GsDevKit_stones/bin:$PATH"
		popd
		export STONES_DATA_HOME="$SMALLTALK_CI_BUILD/.stones_data_home"
		createRegistry.solo $STONES_REGISTRY_NAME
		registryReport.solo
	fold_end clone_gsdevkit_stones
}

################################################################################
# Create a GemStone stone.
################################################################################
gemstone::prepare_stone() {
  local gemstone_version

  gemstone_version="$(echo $1 | cut -f2 -d-)"

  fold_start create_stone "Creating stone..."
      ${GS_HOME}/bin/createStone ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}"
  fold_end create_stone
}

################################################################################
# Load project into GemStone stone.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::load_project() {
  local status=0

  fold_start load_server_project "Loading server project..."
    run_script ${GS_HOME}/bin/startTopaz "${STONE_NAME}" -l -T ${GSCI_TOC:-100000} << EOF || status=$?
      iferr 1 stk
      iferr 2 stack
      iferr 3 exit 1
      login
      run
      GsDeployer bulkMigrate: [
        Metacello new
          baseline: 'SmalltalkCI';
          repository: 'filetree://${SMALLTALK_CI_HOME}/repository';
          load: 'Core'.
        System commitTransaction.
        (Smalltalk at: #SmalltalkCI) load: '${config_ston}'.
      ].
%
      logout
      exit 0
EOF
  fold_end load_server_project

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to load project."
  fi
  check_and_consume_build_status_file
}


################################################################################
# Run tests.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::test_project() {
  local status=0
  local failing_clients=()

  run_script ${GS_HOME}/bin/startTopaz "${STONE_NAME}" -l -T ${GSCI_TOC:-100000} << EOF || status=$?
    iferr 1 stk
    iferr 2 stack
    iferr 3 exit 1
    login
    run
    (Smalltalk at: #SmalltalkCI) test: '${config_ston}' named: '${config_smalltalk} Server (${STONE_NAME})'.
%
    logout
    exit 0
EOF

  if is_nonzero "${status}"; then
    print_error_and_exit "Error while testing server project."
  fi
  check_and_consume_build_status_file

  if is_not_empty  "${DEVKIT_CLIENT_NAMES:-}"; then
    for client_name in "${DEVKIT_CLIENT_NAMES[@]}"
    do
      run_script ${GS_HOME}/bin/startClient ${client_name} -t "${client_name}" -s ${STONE_NAME} -z "${config_ston}" || status=$?

      if is_nonzero "${status}"; then
        print_error_and_exit "Error while testing client project ${client_name}."
      fi
      # Check and consume intermediate build status and keep going
      if current_build_status_signals_error; then
        failing_clients+=("${client_name}")
      fi
      consume_build_status_file
    done
  fi

  # Create build status file for `finalize` step
  if is_nonzero "${#failing_clients[@]}"; then
    echo "Error in the following client(s): ${failing_clients[*]}." > "${build_status_file}"
  else
    echo "[success]" > "${BUILD_STATUS_FILE}"
  fi

  fold_start stop_stone "Stopping stone..."
    ${GS_HOME}/bin/stopStone -b "${STONE_NAME}"
  fold_end stop_stone
}

################################################################################
# Main entry point for GemStone builds.
################################################################################
run_build() {
  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "GemStone is not supported on '$(uname -s)'"
      ;;
  esac

	gemstone::prepare_superDoit
	gemstone::prepare_gsdevkit_stones
  gemstone::prepare_stone "${config_smalltalk}"
#  gemstone::prepare_optional_clients
#  gemstone::load_project
#  gemstone::test_project
}


