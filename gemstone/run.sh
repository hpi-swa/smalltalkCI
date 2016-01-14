#!/bin/bash

set -e

readonly GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"

################################################################################
# Clone the GsDevKit_home project. 
################################################################################
gemstone::prepare_gsdevkit_home() {
  local devkit_branch="dev"

  travis_fold start clone_gsdevkit "Cloning GsDevKit..."
    git clone "${GS_DEVKIT_DOWNLOAD}"
    cd "GsDevKit_home"
    git checkout "${devkit_branch}"
    export GS_HOME="$(pwd)"
  travis_fold end clone_gsdevkit

  return 0
}

################################################################################
# Create a GemStone stone. 
# Arguments:
#   stone_name
#   config_smalltalk
################################################################################
gemstone::prepare_stone() {
  local stone_name=$1
  local gemstone_version

  gemstone_version="$(echo $2 | cut -f2 -d-)"

  # Operating system setup already performed
  touch $GS_HOME/bin/.gsdevkitSysSetup

  travis_fold start install_server "Installing server..."
    reset_timer

    $GS_HOME/bin/installServer 

    print_timed_result "Time to install server"
  travis_fold end install_server

  travis_fold start create_stone "Creating stone..."
    reset_timer

    $GS_HOME/bin/createStone $stone_name $gemstone_version

    print_timed_result "Time to create stone"
  travis_fold end create_stone

  return 0
}

################################################################################
# Load project into GemStone stone and run tests.
# Arguments:
#   stone_name
# Locals:
#   config_project_home
# Globals:
#   SMALLTALK_CI_HOME
# Returns:
#   Status code of project loading
################################################################################
gemstone::load_and_test_project() {
  local stone_name=$1
  local status=0

  travis_fold start load_and_test "Loading and testing project..."
    reset_timer

    $GS_HOME/bin/devKitCommandLine serverDoIt ${stone_name} << EOF || status=$?
      (BinaryOrTextFile openReadOnServer: '${SMALLTALK_CI_HOME}/lib/SmalltalkCI-Core.st') 
        fileIn;
        close.
      SmalltalkCISpec automatedTestOf: '${project_home}/smalltalk.ston'
      System commitTransaction.
EOF

    print_timed_result "Time to load and test project"
  travis_fold end load_and_test

  return "${status}"
}

################################################################################
# Main entry point for GemStone builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local stone_name="travis"
  local exit_status=0

  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${stone_name}" "${config_smalltalk}"
  gemstone::load_and_test_project "${stone_name}" || exit_status=$?

  return "${exit_status}"
}
