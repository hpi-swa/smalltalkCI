#!/bin/bash

set -e

readonly GS_STONE_NAME="travis"
readonly GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"
readonly GS_DEVKIT_BRANCH="master"
export GS_HOME="${SMALLTALK_CI_BUILD}/GsDevKit_home"

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

  travis_fold start install_server "Installing server..."
    timer_start

    $GS_HOME/bin/installServer || print_error_and_exit "installServer failed."

    timer_finish
  travis_fold end install_server

  travis_fold start create_stone "Creating stone..."
    timer_start

    $GS_HOME/bin/createStone "$GS_STONE_NAME" $gemstone_version || print_error_and_exit "createStone failed."

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

  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${config_smalltalk}"
  gemstone::load_and_test_project || exit_status=$?

  return "${exit_status}"
}
