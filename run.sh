#!/bin/bash


set -e

readonly SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_PATH}/helpers.sh"

readonly SMALLTALK_CI_DEFAULT_CONFIG='smalltalk.ston'
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
# Set and verify $config_project_home. Use $TRAVIS_BUILD_DIR if set, otherwise
# use path provided as argument.
# Locals:
#   config_project_home
# Globals:
#   TRAVIS_BUILD_DIR
# Arguments:
#   Custom project home path
################################################################################
determine_project_home() {
  local custom_home=$1

  if is_travis_build && ! is_dir "${custom_home}"; then
    config_project_home="${TRAVIS_BUILD_DIR}"
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
# Validate options and exit with '1' if an option is invalid.
# Locals:
#   config_smalltalk
################################################################################
validate_configuration() {
  if is_empty "${config_smalltalk}"; then
    print_error_and_exit "Smalltalk image is not defined."
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
#   config_builder_ci_fallback
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
    -d | --debug)
      config_debug="true"
      shift
      ;;
    -h | --help)
      print_help
      exit 0
      ;;
    --headfull)
      config_headless="false"
      shift
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
# Provide backward compatibility by creating a config file if not present.
# Locals:
#   config_project_home
# Globals:
#   BASELINE
#   PACKAGES
################################################################################
check_backward_compatibility() {
  local load

  if ! is_file "${config_project_home}/${SMALLTALK_CI_DEFAULT_CONFIG}"; then
    print_error "No SmalltalkCISpec found for the project!"
    print_info "Creating a SmalltalkCISpec..."

    case "${config_smalltalk}" in
      Squeak*)
        load="TravisCI"
        ;;
      *)
        load="default"
        ;;
    esac

    cat >${config_project_home}/${SMALLTALK_CI_DEFAULT_CONFIG} <<EOL
SmalltalkCISpec {
  #loadSpecs : [
      SCIMetacelloLoadSpec {
          #baseline : '${BASELINE}',
          #directory : '${PACKAGES}',
          #load : [ '${load}' ],
          #platforms : [ #squeak, #pharo, #gemstone ]
      }
  ]
}
EOL
    print_error "=============================================================="
    cat ${config_project_home}/${SMALLTALK_CI_DEFAULT_CONFIG}
    print_error "=============================================================="
  fi
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
  if is_dir "${SMALLTALK_CI_CACHE}" || \
        ! is_dir "${SMALLTALK_CI_BUILD_BASE}"; then
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
    travis_fold start display_config "Current configuration"
      for var in ${!config_@}; do
        echo "${var}=${!var}"
      done
    travis_fold end display_config
  fi

  run_build
  return $?
}

################################################################################
# Main entry point. Exit with build status code.
# Arguments:
#   All positional parameters
################################################################################
main() {
  local config_smalltalk="${TRAVIS_SMALLTALK_VERSION}"
  local config_project_home
  local config_builder_ci_fallback="false"
  local config_clean="false"
  local config_debug="false"
  local config_headless="true"
  local config_verbose="false"
  local exit_status=0

  check_os
  parse_args "$@"
  [[ "${config_verbose}" = "true" ]] && set -x
  check_and_set_paths
  check_clean_up

  if is_fallback_enabled; then
    builder_ci_fallback || exit_status=$?
  else
    prepare_folders
    check_backward_compatibility
    run || exit_status=$?
    if [[ "${exit_status}" -ne 0 ]]; then
      print_error "Failed to load and test project."
      exit ${exit_status}
    fi
  fi

  print_results "${SMALLTALK_CI_BUILD}" || exit_status=$?
  print_info "Works"
  exit ${exit_status}
}

if [[ "$(basename -- "$0")" = "run.sh" ]]; then
  main "$@"
fi
