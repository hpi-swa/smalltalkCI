#!/bin/bash

set -e

readonly GS_DEVKIT_DOWNLOAD="git@github.com:GsDevKit/GsDevKit_home.git"

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   config_baseline_group
#   config_directory
#   config_tests
################################################################################
gemstone::check_options() {
  is_empty "${config_baseline_group}" && config_baseline_group="default"
  is_empty "${config_directory}" && config_directory=""
  is_empty "${config_tests}" && config_tests="${config_baseline}.*"
  is_empty "${config_devkit_branch}" && config_devkit_branch="dev"
  return 0
}

################################################################################
# Clone the GsDevKit_home project. 
# Arguments:
#   devkit_branch
################################################################################
gemstone::prepar_gsdevkit_home() {
  local devkit_branch=$1

  git clone ${GS_DEVKIT_DOWNLOAD}
  cd GsDevKit_home
  git checkout ${devkit_branch}
  export GS_HOME=`pwd`
  return 0
}

################################################################################
# Create a GemStone stone. 
# Arguments:
#   stone_name
#   gemstone_version
################################################################################
gemstone::prepare_stone() {
  local stone_name=$1
  local gemstone_version=$2
  local setupType=server

  touch $GS_HOME/bin/.gsdevkitSysSetup  # Operating system setup already performed
  $GS_HOME/bin/

}

################################################################################
# Load project into Pharo image.
# Locals:
#   config_baseline
#   config_baseline_group
#   config_directory
#   config_project_home
# Globals:
#   SMALLTALK_CI_VM
#   SMALLTALK_CI_IMAGE
# Returns:
#   Status code of project loading
################################################################################
pharo::load_project() {
  print_info "Loading project..."
  "${SMALLTALK_CI_VM}" "${SMALLTALK_CI_IMAGE}" eval --save "
  Metacello new 
    baseline: '${config_baseline}';
    repository: 'filetree://${config_project_home}/${config_directory}';
    load: '${config_baseline_group}'.
  "
  return $?
}

################################################################################
# Run tests in Pharo image.
# Globals:
#   SMALLTALK_CI_VM
#   SMALLTALK_CI_IMAGE
# Arguments:
#   String matching a package name to test
# Returns:
#   Status code of build
################################################################################
pharo::run_tests() {
  local tests=$1

  print_info "Run tests..."
  "${SMALLTALK_CI_VM}" "${SMALLTALK_CI_IMAGE}" test --junit-xml-output \
      --fail-on-failure "${tests}" 2>&1
  return $?
}

################################################################################
# Main entry point for Pharo builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local exit_status=0

  gemstone::check_options
  gemstone::prepare_gsdevkit_home "${config_devkit_branch}"
  gemstone::prepare_stone "${config_stone_name}" 
  pharo::load_project || exit_status=$?

  if [[ ! ${exit_status} -eq 0 ]]; then
    print_error "Project could not be loaded."
    return "${exit_status}"
  fi

  pharo::run_tests "${config_tests}" || exit_status=$?

  print_junit_xml "${SMALLTALK_CI_BUILD}"

  return "${exit_status}"
}
