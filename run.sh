#!/bin/bash

set -e

readonly DEFAULT_STON_CONFIG='smalltalk.ston'

################################################################################
# Determine $SCRIPT_PATH and load helpers.
################################################################################
initialize() {
  local base_path="${BASH_SOURCE[0]}"

  # Resolve symlink if necessary and fail if OS is not supported
  case "$(uname -s)" in
    "Linux")
      base_path="$(readlink -f "${base_path}")" || true
      ;;
    "Darwin")
      base_path="$(readlink "${base_path}")" || true
      ;;
    *)
      echo "Unsupported platform '${os_name}'." 1>&2
      exit 1
      ;;
  esac

  readonly SCRIPT_PATH="$(cd "$(dirname "${base_path}")" && pwd)"

  if [[ ! -f "${SCRIPT_PATH}/helpers.sh" ]]; then
    echo "smalltalkCI could not be initialized." 1>&2
    exit 1
  fi

  # Load helpers
  source "${SCRIPT_PATH}/helpers.sh"
}

################################################################################
# Set and verify $config_project_home and $config_ston if applicable.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   TRAVIS_BUILD_DIR
# Arguments:
#   Custom project home path
################################################################################
determine_project() {
  local custom_ston=$1

  if ! is_empty "${custom_ston}" && is_file "${custom_ston}" && \
      [[ ${custom_ston: -5} == ".ston" ]]; then
    config_ston=$(basename "${custom_ston}")
    config_project_home="$(dirname "${custom_ston}")"
  elif is_travis_build; then
    config_project_home="${TRAVIS_BUILD_DIR}"
    locate_ston_config
  else
    print_error_and_exit "No valid STON provided and not running on Travis."
  fi

  # Convert to absolute path if necessary
  if [[ "${config_project_home:0:1}" != "/" ]]; then
    config_project_home="$(cd "${config_project_home}" && pwd)"
  fi

  if ! is_dir "${config_project_home}"; then
    print_error_and_exit "Project home cannot be found."
  fi
}

################################################################################
# Allow STON config filename to start with a dot.
# Locals:
#   config_project_home
# Globals:
#   DEFAULT_STON_CONFIG
################################################################################
locate_ston_config() {
  if ! is_file "${config_project_home}/${DEFAULT_STON_CONFIG}"; then
    if is_file "${config_project_home}/.${DEFAULT_STON_CONFIG}"; then
      config_ston=".${DEFAULT_STON_CONFIG}"
    else
      print_error_and_exit "No STON file named '${DEFAULT_STON_CONFIG}'' found
                            in ${config_project_home}."
    fi
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
#   config_smalltalk
# Arguments:
#   All positional parameters
################################################################################
parse_args() {
  if ! is_travis_build && [[ $# -eq 0 ]]; then
    print_help
    exit 0
  fi

  # Handle all arguments and flags
  while :
  do
    case "$1" in
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
  local config_ston="${DEFAULT_STON_CONFIG}"
  local config_project_home
  local config_builder_ci_fallback="false"
  local config_clean="false"
  local config_debug="false"
  local config_headless="true"
  local config_verbose="false"
  local exit_status=0

  initialize
  parse_args "$@"
  [[ "${config_verbose}" = "true" ]] && set -x
  determine_project "${!#}"  # Use last argument for custom STON
  check_and_set_paths
  check_clean_up

  prepare_folders
  run || exit_status=$?
  if [[ "${exit_status}" -ne 0 ]]; then
    print_error "Failed to load and test project."
    exit ${exit_status}
  fi

  print_results "${SMALLTALK_CI_BUILD}" || exit_status=$?
  exit ${exit_status}
}

main "$@"
