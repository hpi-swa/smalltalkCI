#!/bin/bash

set -e

readonly GS_DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"

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
  is_empty "${config_gemstone_version}" && config_gemstone_version=`echo ${config_smalltalk} | cut -f2 -d-`
  is_empty "${config_stone_name}" && config_stone_name="travis"
  return 0
}

################################################################################
# Clone the GsDevKit_home project. 
# Arguments:
#   devkit_branch
################################################################################
gemstone::prepare_gsdevkit_home() {
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

  # uncomment the following when os prereqs handled in smalltalk.rb - https://github.com/hpi-swa/smalltalkCI/issues/28
  # touch $GS_HOME/bin/.gsdevkitSysSetup  # Operating system setup already performed
  $GS_HOME/bin/installServer 
  $GS_HOME/bin/createStone $stone_name $gemstone_version

  echo "DEBUG: session description"
  cat $GS_HOME/sys/local/sessions/${stone_name}
  cat /etc/hosts
  return 0
}

################################################################################
# Load project into GemStone stone.
# Arguments:
#   stone_name
# Locals:
#   config_baseline
#   config_baseline_group
#   config_directory
#   config_project_home
# Returns:
#   Status code of project loading
################################################################################
gemstone::load_project() {
  local stone_name=$1

  print_info "Loading project..."
  $GS_HOME/bin/devKitCommandLine todeIt ${stone_name} << EOF
    eval \`
      Metacello new baseline: '${config_baseline}'; \\ 
        repository: 'filetree://${config_project_home}/${config_directory}'; \\ 
        load: '${config_baseline_group}'. \\
      \`
EOF
  return $?
}

################################################################################
# Run tests in GemStone stone.
# Arguments:
#   stone_name
#   The name of project to test
# Returns:
#   Status code of build
################################################################################
gemstone::run_tests() {
  local stone_name=$1
  local project_name=$2

  print_info "Run tests..."
  $GS_HOME/bin/devKitCommandLine todeIt ${stone_name} << EOF
    test --batch project ${project_name}
EOF
  return $?
}

################################################################################
# Main entry point for GemStone builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local exit_status=0

  sudo hostname smalltalkci
  echo "DEBUG: hostname: `hostname`"
  cat /etc/hosts
  gemstone::check_options
  gemstone::prepare_gsdevkit_home "${config_devkit_branch}"
  gemstone::prepare_stone "${config_stone_name}" "${config_gemstone_version}"
  gemstone::load_project "${config_stone_name}" || exit_status=$?

  if [[ ! ${exit_status} -eq 0 ]]; then
    print_error "Project could not be loaded."
    return "${exit_status}"
  fi

  gemstone::run_tests "${config_stone_name}" "${config_baseline}" || exit_status=$?

  return "${exit_status}"
}
