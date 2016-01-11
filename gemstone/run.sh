#!/bin/bash

set -e

readonly GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"

################################################################################
# Clone the GsDevKit_home project. 
################################################################################
gemstone::prepare_gsdevkit_home() {
  local devkit_branch="dev"

  git clone "${GS_DEVKIT_DOWNLOAD}"
  cd "GsDevKit_home"
  git checkout "${devkit_branch}"
  export GS_HOME="$(pwd)"
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

  # uncomment the following when os prereqs handled in smalltalk.rb - https://github.com/hpi-swa/smalltalkCI/issues/28
  # touch $GS_HOME/bin/.gsdevkitSysSetup  # Operating system setup already performed
  $GS_HOME/bin/installServer 
  $GS_HOME/bin/createStone $stone_name $gemstone_version

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

  print_info "Loading project..."

  $GS_HOME/bin/devKitCommandLine serverDoIt ${stone_name} << EOF
    (BinaryOrTextFile openReadOnServer: '${SMALLTALK_CI_HOME}/lib/SmalltalkCI-Core.st') 
      fileIn;
      close.
    SmalltalkCISpec automatedTestOf: '${project_home}/smalltalk.ston'
    System commitTransaction.
EOF
  return $?
}

################################################################################
# Main entry point for GemStone builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local stone_name="travis"
  local exit_status=0

  # not needed when https://github.com/hpi-swa/smalltalkCI/issues/28 fixed
  if [[ "${TRAVIS_OS_NAME}" = "linux" ]]; then
    sudo hostname travis.dev
  elif [[ "${TRAVIS_OS_NAME}" = "osx" ]]; then
    sudo scutil --set HostName travis.dev
  fi

  gemstone::prepare_gsdevkit_home
  gemstone::prepare_stone "${stone_name}" "${config_smalltalk}"
  gemstone::load_and_test_project "${stone_name}" || exit_status=$?

  return "${exit_status}"
}
