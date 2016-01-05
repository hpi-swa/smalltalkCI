#!/bin/bash


set -e

readonly SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_PATH}/helpers.sh"

readonly BUILDER_CI_REPO_URL="https://github.com/dalehenrich/builderCI"
readonly BUILDER_CI_DOWNLOAD_URL="${BUILDER_CI_REPO_URL}/archive/master.zip"

################################################################################
# Check OS to be Linux or OS X, otherwise exit with '1'.
################################################################################
check_os() {
  local os_name=$(uname -s)
  case "${os_name}" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "Unsupported platform '${os_name}'."
      ;;
  esac
}

################################################################################
# Set and verify $config_project_home. Use $PROJECT_HOME if set, otherwise use
# path provided as argument.
# Locals:
#   config_project_home
# Globals:
#   PROJECT_HOME
# Arguments:
#   Custom project home path
################################################################################
determine_project_home() {
  local custom_home=$1

  if is_not_empty "${PROJECT_HOME}"; then
    config_project_home="${PROJECT_HOME}"
  else
    config_project_home="${custom_home}"
  fi

  if ! is_dir "${config_project_home}"; then
    print_error_and_exit "Project home is not found."
  fi

  if [[ "${config_project_home:0:1}" != "/" ]]; then
    config_project_home="$(cd "${config_project_home}" && pwd)"
  fi
}

################################################################################
# Use global environment variables to set local configuration variables.
# Locals:
#   config_baseline_group
#   config_directory
#   config_force_update
#   config_builder_ci_fallback
#   config_run_script
#   config_excluded_categories
#   config_excluded_classes
#   config_keep_open
# Globals:
#   BASELINE_GROUP
#   BUILDERCI
#   EXCLUDE_CATEGORIES
#   EXCLUDE_CLASSES
#   FORCE_UPDATE
#   KEEP_OPEN
#   PACKAGES
#   RUN_SCRIPT
################################################################################
load_config_from_environment() {
  is_not_empty "${BASELINE_GROUP}" \
      && config_baseline_group="${BASELINE_GROUP}"
  is_not_empty "${PACKAGES}" \
      && config_directory="${PACKAGES}"
  is_not_empty "${FORCE_UPDATE}" \
      && config_force_update="${FORCE_UPDATE}"
  is_not_empty "${BUILDERCI}" \
      && config_builder_ci_fallback="${BUILDERCI}"
  is_not_empty "${RUN_SCRIPT}" \
      && config_run_script="${RUN_SCRIPT}"
  is_not_empty "${EXCLUDE_CATEGORIES}" \
      && config_excluded_categories="${EXCLUDE_CATEGORIES}"
  is_not_empty "${EXCLUDE_CLASSES}" \
      && config_excluded_classes="${EXCLUDE_CLASSES}"
  is_not_empty "${KEEP_OPEN}" \
      && config_keep_open="${KEEP_OPEN}"
  return 0
}

################################################################################
# Check if project's '.travis.yml' exists and call yml parser to load config.
# Locales:
#   project_home
################################################################################
load_config_from_yml() {
  local user_travis_conf="${config_project_home}/.travis.yml"

  if is_file "${user_travis_conf}"; then
    eval "$(ruby "${SCRIPT_PATH}/yaml_parser.rb" "${user_travis_conf}")"
  else
    print_notice "Could not find '${user_travis_conf}'."
  fi
}

################################################################################
# Validate options and exit with '1' if an option is invalid.
# Locals:
#   config_smalltalk
#   config_baseline
#   config_directory
################################################################################
validate_configuration() {
  if is_empty "${config_smalltalk}"; then
    print_error_and_exit "Smalltalk image is not defined."
  fi
  if is_empty "${config_baseline}" && is_empty "${config_configuration}"; then
    print_error_and_exit "No Metacello baseline or configuration specified."
  fi
  if [[ "${directory:0:1}" = "/" ]]; then
    directory=${directory:1}
    print_notice "Please remove the leading slash from 'directory'."
  fi
}

################################################################################
# Make sure global path variables are set for local builds.
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
check_and_set_paths() {
  if is_empty "${SMALLTALK_CI_HOME}" && ! is_travis_build; then
    export SMALLTALK_CI_HOME="${SCRIPT_PATH}"
    source "${SMALLTALK_CI_HOME}/env_vars"
  fi
}

################################################################################
# Load options from project's '.travis.yml', global environment variables and
# user's parameters.
# Locals:
#   config_baseline
#   config_baseline_group
#   config_builder_ci_fallback
#   config_directory
#   config_excluded_categories
#   config_excluded_classes
#   config_force_update
#   config_keep_open
#   config_run_script
#   config_smalltalk
# Arguments:
#   All positional parameters
################################################################################
parse_args() {
  if ! is_travis_build && [[ $# -eq 0 ]]; then
    print_help
    exit 0
  fi  

  determine_project_home "${!#}" # Use last argument as fallback path
  load_config_from_yml
  load_config_from_environment


  # Handle all arguments and flags
  while :
  do
    case "$1" in
    --builder-ci)
      config_builder_ci_fallback="true"
      shift
      ;;
    --clean)
      config_clean="true"
      shift
      ;;
    --directory)
      config_directory="$2"
      shift 2
      ;;
    -d | --debug)
      config_debug="true"
      shift
      ;;
    --excluded-categories)
      config_excluded_categories="$2"
      shift 2
      ;;
    --excluded-classes)
      config_excluded_classes="$2"
      shift 2
      ;;
    --force-update)
      config_force_update="true"
      shift
      ;;
    -h | --help)
      print_help
      exit 0
      ;;
    --mc-baseline)
      config_baseline="$2"
      # Clear configuration
      config_configuration=""
      shift 2
      ;;
    --mc-baseline-group)
      config_baseline_group="$2"
      shift 2
      ;;
    --mc-config)
      config_configuration="$2"
      # Clear baseline
      config_baseline=""
      shift 2
      ;;
    --mc-config-version)
      config_configuration_version="$2"
      shift 2
      ;;
    -o | --keep-open)
      config_keep_open="true"
      shift
      ;;
    --script)
      config_run_script="$2"
      shift 2
      ;;
    -s | --smalltalk)
      config_smalltalk="$2"
      shift 2
      ;;
    -v | --verbose)
      config_verbose="true"
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      print_error_and_exit "Unknown option: $1"
      ;;
    *) 
      break
      ;;
    esac
  done

  validate_configuration
}

is_fallback_enabled() {
  [[ "${config_builder_ci_fallback}" = "true" ]]
}

################################################################################
# Initiate builderCI fallback build.
# Locals:
#   config_smalltalk
#   config_project_home
# Globals:
#   BUILDER_CI_DOWNLOAD_URL
# Returns:
#   builderCI status code
################################################################################
builder_ci_fallback() {
  # Make sure the script runs on Linux
  if [[ "$(uname -s)" != "Linux" ]]; then
    print_error_and_exit "builderCI only supports Linux builds."
  fi
  if is_travis_build; then
    # Make sure the script runs on standard infrastructure
    sudo -n true
    if [[ "$?" != 0 ]]; then
      print_error_and_exit "sudo is not available."
    fi
  fi

  print_info "Starting legacy build using builderCI..."
  export ST="${config_smalltalk}"
  export PROJECT_HOME="${config_project_home}"
  cd "${HOME}"
  wget -q -O builderCI.zip "${BUILDER_CI_DOWNLOAD_URL}"
  unzip -q builderCI.zip
  cd builderCI-*
  source build_env_vars
  ln -s "${PROJECT_HOME}" "${GIT_PATH}"
  print_info "builderCI: Build image..."
  ./build_image.sh
  print_info "builderCI: Run tests..."
  "$BUILDER_CI_HOME/testTravisCI.sh" -verbose
  return $?
}

################################################################################
# Make sure all required folders exist, create build folder and symlink project.
# Locals:
#   config_project_home
# Globals:
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD_BASE
#   SMALLTALK_CI_VMS
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_GIT
################################################################################
prepare_folders() {
  print_info "Preparing folders..."
  is_dir "${SMALLTALK_CI_CACHE}" || mkdir "${SMALLTALK_CI_CACHE}"
  is_dir "${SMALLTALK_CI_BUILD_BASE}" || mkdir "${SMALLTALK_CI_BUILD_BASE}"
  is_dir "${SMALLTALK_CI_VMS}" || mkdir "${SMALLTALK_CI_VMS}"

  # Create folder for this build
  if is_dir "${SMALLTALK_CI_BUILD}"; then
    print_info "Build folder already exists at ${SMALLTALK_CI_BUILD}."
  else
    mkdir "${SMALLTALK_CI_BUILD}"
  fi

  # Link project folder to git_cache
  ln -s "${config_project_home}" "${SMALLTALK_CI_GIT}"
}


################################################################################
# Run cleanup if requested by user.
# Locals:
#   config_clean
################################################################################
check_clean_up() {
  local user_input
  local question1="Are you sure you want to clear builds and cache? (y/N): "
  local question2="Continue with build? (y/N): "
  if [[ "${config_clean}" = "true" ]]; then
    read -p "${question1}" user_input
    if [[ "${user_input}" = "y" ]]; then
      clean_up
    fi
    read -p "${question2}" user_input
    [[ "${user_input}" != "y" ]] && exit 0
  fi
  return 0
}

################################################################################
# Remove all builds and clear cache.
# Globals:
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD_BASE
################################################################################
clean_up() {
  if is_dir "${SMALLTALK_CI_CACHE}" || ! is_dir "${SMALLTALK_CI_BUILD_BASE}"; then
    print_info "Cleaning up..."
    print_info "Removing the following directories:"
    print_info "  ${SMALLTALK_CI_CACHE}"
    print_info "  ${SMALLTALK_CI_BUILD_BASE}"
    rm -rf "${SMALLTALK_CI_CACHE}" "${SMALLTALK_CI_BUILD_BASE}"
    print_info "Done."
  else
    print_notice "Nothing to clean up."
  fi
}

################################################################################
# Load platform-specific package and run the build.
# Locals:
#   config_smalltalk
# Returns:
#   Status code of build
################################################################################
run() {
  case "${config_smalltalk}" in
    Squeak*)
      print_info "Starting Squeak build..."
      source "${SMALLTALK_CI_HOME}/squeak/run.sh"
      ;;
    Pharo*)
      print_info "Starting Pharo build..."
      source "${SMALLTALK_CI_HOME}/pharo/run.sh"
      ;;
    GemStone*)
      print_info "Starting GemStone build..."
      source "${SMALLTALK_CI_HOME}/gemstone/run.sh"
      ;;
    *)
      print_error_and_exit "Unknown Smalltalk version '${config_smalltalk}'."
      ;;
  esac

  if debug_enabled; then
    print_debug "Configuration before platform-specific code:"
    for var in ${!config_@}; do
      print_debug "${var}=${!var}"
    done
  fi

  run_build
  return $?
}

################################################################################
# Print success or failure message according to the status code provided.
# Arguments:
#   Status code
################################################################################
check_build_status() {
  local status=$1

  printf "\n\n"
  if [[ ${status} -eq 0 ]]; then
    print_success "Build successful :)"
  else
    print_error "Build failed :("
    if is_travis_build; then
      printf "\n\n"
      print_info "To reproduce the failed build locally, download
        smalltalkCI and try running something like:"
      printf "\n"
      print_notice "./run.sh -o -s \"${config_smalltalk}\" /path/to/project"
    fi
  fi
  printf "\n"
}

################################################################################
# Main entry point. Exit with build status code.
# Arguments:
#   All positional parameters
################################################################################
main() {
  local config_smalltalk="${SMALLTALK}"
  local config_project_home
  local config_baseline
  local config_baseline_group
  local config_builder_ci_fallback="false"
  local config_clean="false"
  local config_configuration
  local config_configuration_version="#stable"
  local config_debug="false"
  local config_directory="packages"
  local config_excluded_categories
  local config_excluded_classes
  local config_force_update
  local config_keep_open="false"
  local config_run_script
  local config_tests
  local config_verbose="false"
  local exit_status=0

  if [ "${TRAVIS_OS_NAME}" = "linux" ] ; then
    sudo hostname travis.dev
  else "then osx"
    sudo scutil --set HostName travis.dev
  fi
  check_os
  parse_args "$@"
  [[ "${config_verbose}" = "true" ]] && set -x
  check_and_set_paths
  check_clean_up

  if is_fallback_enabled; then
    builder_ci_fallback || exit_status=$?
  else
    prepare_folders
    run || exit_status=$?
  fi
  
  check_build_status "${exit_status}"
  exit ${exit_status}
}

if [[ "$(basename -- "$0")" = "run.sh" ]]; then
  main "$@"
fi
