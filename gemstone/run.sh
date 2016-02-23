#!/bin/bash

set -e

readonly GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"

################################################################################
# Clone the GsDevKit_home project.
################################################################################
gemstone::prepare_gsdevkit_home() {
  local devkit_branch="dev"

  travis_fold start clone_gsdevkit "Cloning GsDevKit..."
    timer_start

    git clone "${GS_DEVKIT_DOWNLOAD}"
    cd "GsDevKit_home"
    git checkout "${devkit_branch}"
    export GS_HOME="$(pwd)"

    timer_finish
  travis_fold end clone_gsdevkit
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

  export GS_TRAVIS=true # install special key files for running GemStone on Travis hosts

  travis_fold start install_server "Installing server..."
    timer_start

    $GS_HOME/bin/installServer
    if [[ ! $? -eq 0 ]]; then
        print_error_and_exit "installServer failed."
    fi

    timer_finish
  travis_fold end install_server

  travis_fold start create_stone "Creating stone..."
    timer_start

    $GS_HOME/bin/createStone $stone_name $gemstone_version
    if [[ ! $? -eq 0 ]]; then
        print_error_and_exit "createStone failed."
    fi

    timer_finish
  travis_fold end create_stone

  # logging for https://github.com/hpi-swa/smalltalkCI/pull/51
  echo "session description"
  cat $GS_HOME/sys/local/sessions/$stone_name
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
    timer_start

    $GS_HOME/bin/devKitCommandLine serverDoIt ${stone_name} << EOF || status=$?
      Metacello new
        baseline: 'SmalltalkCI';
	repository: 'filetree://${SMALLTALK_CI_HOME}/gemstone/repository';
	load: 'Core'.
      (Smalltalk at: #SmalltalkCI) runCIFor: '${project_home}/${SMALLTALK_CI_DEFAULT_CONFIG}'.
      System commitTransaction.
EOF

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
  local stone_name="travis"
  local exit_status=0

  echo "Are the host names set up correctly for GemStone?"
  hostname
  cat /etc/hosts
  echo "Well?"
  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${stone_name}" "${config_smalltalk}"
  gemstone::load_and_test_project "${stone_name}" || exit_status=$?

  return "${exit_status}"
}
