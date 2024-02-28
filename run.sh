#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o pipefail
set -o nounset

readonly BINTRAY_API="https://api.bintray.com/content"
readonly DEFAULT_STON_CONFIG="smalltalk.ston"
readonly GITHUB_REPO_URL="https://github.com/hpi-swa/smalltalkCI"

# Indicates whether any secondary action was chosen that makes the execution
# of the actual build process optional. See ensure_ston_config_exists.
first_action=""

################################################################################
# Locate $SMALLTALK_CI_HOME and load helpers.
################################################################################
initialize() {
  local resolved_path

  # Set up traps, otherwise fail if OS is not supported
  case "$(uname -s)" in
    "Linux"|"Darwin"|"CYGWIN_NT-"*|"MINGW64_NT-"*|"MSYS_NT-"*)
      trap handle_exit EXIT
      trap handle_error ERR
      trap handle_interrupt INT
      ;;
    *)
      echo "Unsupported platform '$(uname -s)'." 1>&2
      exit 1
      ;;
  esac

  if [[ "$@" = *--self-test* ]]; then
    # Unset all `SMALLTALK_CI_*` environment variables for self testing
    for var in ${!SMALLTALK_CI_@}; do
      unset "${var}"
    done
  fi

  if [[ -z "${SMALLTALK_CI_HOME:-}" ]]; then
    # Try to determine absolute path to smalltalkCI
    export SMALLTALK_CI_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    if [[ ! -f "${SMALLTALK_CI_HOME}/run.sh" ]]; then
      # Try to resolve symlink
      case "$(uname -s)" in
        "Linux")
          resolved_path="$(readlink -f "${BASH_SOURCE[0]}")" || true
          ;;
        "Darwin")
          resolved_path="$(readlink "${BASH_SOURCE[0]}")" || true
          ;;
      esac
      SMALLTALK_CI_HOME=$(dirname "${resolved_path}")
    fi

    if [[ ! -f "${SMALLTALK_CI_HOME}/run.sh" ]]; then
      echo "Unable to locate smalltalkCI directory." 1>&2
      exit 1
    fi

    # Load environment variables
    source "${SMALLTALK_CI_HOME}/env_vars"
  fi

  if [[ ! -f "${SMALLTALK_CI_HOME}/run.sh" ]]; then
    echo "smalltalkCI could not be initialized." 1>&2
    exit 1
  fi

  # Load helpers
  source "${SMALLTALK_CI_HOME}/helpers.sh"
  smalltalk_ci_start_time=$(timer_nanoseconds)
}

################################################################################
# Exit handler.
################################################################################
handle_exit() {
  local error_code=$?
  report_build_metrics "${error_code}"
  exit "${error_code}"
}

################################################################################
# Print error information and exit.
################################################################################
handle_error() {
  local error_code=$?
  local num_crash_lines=250
  local i

  if is_file "${SMALLTALK_CI_BUILD}/crash.dmp"; then
    print_notice "Found a crash.dmp. Here are the first ${num_crash_lines} lines:"
    head -n ${num_crash_lines} "${SMALLTALK_CI_BUILD}/crash.dmp"
  fi

  printf "\n"
  print_notice "Error with status code ${error_code}:"
  i=0
  while caller $i;
    do ((i++));
  done
  printf "===================================================================\n"
  print_config
  exit "${error_code}"
}

################################################################################
# Print notice on interrupt and exit.
################################################################################
handle_interrupt() {
  print_notice $'\nsmalltalkCI has been interrupted. Exiting...'
  exit 1
}

################################################################################
# Ensure $config_ston is an existing STON file.
# Locals:
#   config_ston
# Arguments:
#   Custom project home path
################################################################################
ensure_ston_config_exists() {
  local custom_ston=$1

  # STON provided as cmd line parameter can override $config_ston
  if ! is_empty "${custom_ston}"; then
    if [[ ${custom_ston: -5} != ".ston" ]] || ! is_file "${custom_ston}"; then
      print_error_and_exit "User-provided configuration is not a STON-file or \
could not be found at '${custom_ston}'."
    fi
    config_ston="${custom_ston}"
    # Expand path if $config_ston does not start with / or ~
    if ! [[ "${config_ston:0:1}" =~ (\/|\~) ]]; then
      config_ston="$(pwd)/${config_ston}"
    fi
    return
  fi

  if is_travis_build; then
    if is_not_empty "${TRAVIS_SMALLTALK_CONFIG:-}"; then
      # If the variable is a list (ruby array like ["a", "b", "c"]) extract the first value
      # This is a workaround for https://github.com/hpi-swa/smalltalkCI/issues/448
      first_config="$(echo ${TRAVIS_SMALLTALK_CONFIG//[\[\]]} | awk -F',' '{print $1}')"
      config_ston="${TRAVIS_BUILD_DIR}/${first_config}"
    else
      locate_ston_config
    fi
  elif is_file "${config_ston}"; then
    # Make sure $config_ston does not start with ./
    config_ston="${config_ston#./}"

    # Expand path if $config_ston does not start with / or ~
    if ! [[ "${config_ston:0:1}" =~ (\/|\~) ]]; then
      config_ston="$(pwd)/${config_ston}"
    fi
  else
    locate_ston_config
  fi

  # Resolve absolute path if necessary
  if [[ "${config_ston:0:1}" != "/" ]]; then
    case "$(uname -s)" in
      "Linux")
        config_ston="$(readlink -f "${config_ston}")" || true
        ;;
      "Darwin")
        config_ston="$(readlink "${config_ston}")" || true
        ;;
    esac
  fi

  if ! is_empty "${first_action}"; then
    if ! is_file "${config_ston}"; then
      exit
    fi
    read -p "Continue with build progress? (y/N): " user_input
    [[ "${user_input}" != "y" ]] && exit 0
  elif ! is_file "${config_ston}"; then
    print_error_and_exit "STON configuration could not be found at \
'${config_ston}'."
  fi
}

################################################################################
# Allow STON config filename to start with a dot.
# Locals:
#   config_ston
# Globals:
#   TRAVIS_BUILD_DIR
################################################################################
locate_ston_config() {
  local project_home

  if is_travis_build; then
    project_home="${TRAVIS_BUILD_DIR}"
  else
    project_home="$(pwd)"
  fi

  if is_file "${project_home}/${DEFAULT_STON_CONFIG}"; then
    config_ston="${project_home}/${DEFAULT_STON_CONFIG}"
  elif is_file "${project_home}/.${DEFAULT_STON_CONFIG}"; then
    config_ston="${project_home}/.${DEFAULT_STON_CONFIG}"
  else
    if ! is_empty "${first_action}"; then
      exit
    fi
    print_error_and_exit "No STON file named '.${DEFAULT_STON_CONFIG}' found \
in ${project_home}."
  fi
}

################################################################################
# Select Smalltalk image interactively if not already selected.
# Locals:
#   config_smalltalk
################################################################################
select_smalltalk() {
  local images="Squeak64-trunk Squeak64-6.0 Squeak64-5.3 Squeak64-5.2 Squeak64-5.1
                Squeak32-trunk Squeak32-6.0 Squeak32-5.3 Squeak32-5.2 Squeak32-5.1 Squeak32-5.0
                Squeak32-4.6 Squeak32-4.5
                Pharo64-stable Pharo64-alpha Pharo64-12 Pharo64-11 Pharo64-10 Pharo64-9.0 Pharo64-8.0 Pharo64-7.0 Pharo64-6.1 Pharo64-6.0
                Pharo32-stable Pharo32-alpha Pharo32-12 Pharo32-9.0 Pharo32-8.0 Pharo32-7.0 Pharo32-6.0 Pharo32-5.0
                Pharo32-4.0 Pharo32-3.0
                GemStone64-3.6.5 GemStone64-3.6.0 GemStone64-3.5.8 GemStone64-3.5.3
                GToolkit64-release
                Moose64-trunk Moose64-10 Moose64-9.0 Moose64-8.0 Moose64-7.0
                Moose32-trunk Moose32-8.0 Moose32-7.0 Moose32-6.1 Moose32-6.0"

  if is_not_empty "${config_smalltalk}"; then
    return
  fi

  if is_travis_build || is_appveyor_build; then
    config_smalltalk="${TRAVIS_SMALLTALK_VERSION:-${SMALLTALK}}"
    return
  fi

  # Ask user to choose an image if one has not been selected yet
  if is_empty "${config_smalltalk}"; then
    PS3="Choose Smalltalk image: "
    set -o posix  # fixes SIGINT during select
    select selection in $images; do
      case "${selection}" in
        Squeak*|Pharo*|GemStone*|GToolkit*|Moose*)
          config_smalltalk="${selection}"
          break
          ;;
        *)
          print_error_and_exit "No Smalltalk image selected."
          ;;
      esac
    done
    set +o posix
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
  if [[ "${config_smalltalk}" != *"64-"* ]] && \
     [[ "${config_smalltalk}" != *"32-"* ]]; then
    print_notice 'Please consider explicitly specifying image architecture
(Example: use `Squeak64-trunk` instead of `Squeak-trunk`).'
  fi
  if is_empty "${config_ston}"; then
    print_error_and_exit "No STON file found."
  elif ! is_file "${config_ston}"; then
    print_error_and_exit "STON file at '${config_ston}' does not exist."
  fi
}

################################################################################
# Set options that depend on the context, i.e., the input values and selections
# performed so far.
################################################################################
set_context_options() {
  if [[ "${config_force_cache}" = "true" ]]; then
    print_info "Forcing cache use"
    config_overwrite_cache="false"
  else
    case "${config_smalltalk}" in
      *-alpha | *-trunk)
        print_info "Forcing image update for in-development version"
        config_overwrite_cache="true"
        ;;
      *)
        ;;
    esac
  fi
}

################################################################################
# Handle user-defined options.
# Locals:
#   config_clean
#   config_debug
#   config_headless
#   config_overwrite_cache
#   config_smalltalk
#   config_verbose
# Arguments:
#   All positional parameters
################################################################################
parse_options() {
  local positional=()

  while [[ $# -gt 0 ]]
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
    --gs-*)
      # Reserved namespace for GemStone options
      shift
      ;;
    -h | --help)
      print_help
      exit 0
      ;;
    --headful | --headfull)
      config_headless="false"
      shift
      ;;
    --image)
      config_image="${2:-}"
      if ! is_file "${config_image}"; then
        print_error_and_exit "${config_image} does not exist"
      fi
      shift 2
      ;;
    --force-cache)
      config_force_cache="true"
      shift
      ;;
    --no-color)
      config_colorful="false"
      shift
      ;;
    --no-tracking)
      config_tracking="false"
      shift
      ;;
    --overwrite-cache)
      config_overwrite_cache="true"
      shift
      ;;
    --print-env)
      print_env
      exit 0
      ;;
    -s | --smalltalk)
      config_smalltalk="${2:-}"
      if is_empty "${config_smalltalk}"; then
        print_error_and_exit "-s | --smalltalk option requires an argument \
(e.g. 'smalltalkci -s Squeak64-trunk')."
      fi
      shift 2
      ;;
    -v | --verbose)
      config_verbose="true"
      shift
      ;;
    --vm)
      config_vm="${2:-}"
      if ! is_file "${config_vm}"; then
        print_error_and_exit "${config_vm} does not exist"
      fi
      shift 2
      ;;
    -- | --self-test)
      shift
      ;;
    -*)
      print_error_and_exit "Unknown option: $1"
      ;;
    *)
      positional+=("$1")
      shift
      ;;
    esac
  done

  if [[ "${#positional[@]}" -gt 1 ]]; then
    print_error_and_exit "Too many positional arguments: '${positional[*]:-}'"
  else
    config_first_arg_or_empty="${positional:-}"
  fi
}

################################################################################
# Make sure all required folders exist, create build folder and symlink project.
# Locals:
#   config_ston
# Globals:
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD_BASE
#   SMALLTALK_CI_BUILD
################################################################################
prepare_folders() {
  print_info "Preparing folders..."
  is_dir "${SMALLTALK_CI_CACHE}" || mkdir "${SMALLTALK_CI_CACHE}"
  is_dir "${SMALLTALK_CI_BUILD_BASE}" || mkdir "${SMALLTALK_CI_BUILD_BASE}"

  # Create folder for this build
  if is_dir "${SMALLTALK_CI_BUILD}"; then
    print_info "Build folder already exists at ${SMALLTALK_CI_BUILD}."
  else
    mkdir "${SMALLTALK_CI_BUILD}"
  fi
}

################################################################################
# Set up build environment.
################################################################################
prepare_environment() {
  add_env_vars
  if is_linux_build && is_sudo_enabled; then
    raise_rtprio_limit
  fi
}

################################################################################
# Add environment variables for in-image use (with `SCIII_` prefix).
################################################################################
add_env_vars() {
  export SCIII_SMALLTALK="${config_smalltalk}"
  export SCIII_BUILD="$(resolve_path "${SMALLTALK_CI_BUILD}")"
  export SCIII_COLORFUL="${config_colorful}"
  export SCIII_DEBUG="${config_debug}"
}

################################################################################
# Raise RTPRIO of current bash for OpenSmalltalk VMs with threaded heartbeat.
################################################################################
raise_rtprio_limit() {
  if ! program_exists "gcc"; then
    print_info "Unable to raise real-time priority: gcc is not available."
    return
  fi

  fold_start set_rtprio_limit "Raising real-time priority for OpenSmalltalk VMs with threaded heartbeat..."
  pushd $(mktemp -d) > /dev/null
  gcc -o "set_rtprio_limit" "${SMALLTALK_CI_HOME}/utils/set_rtprio_limit.c"
  chmod +x "./set_rtprio_limit"
  sudo "./set_rtprio_limit" $$ || true
  popd > /dev/null
  fold_end set_rtprio_limit
}

################################################################################
# Run cleanup if requested by user.
# Locals:
#   config_clean
################################################################################
check_clean_up() {
  local user_input
  if [[ "${config_clean}" != "true" ]]; then
    return 0
  fi
  print_info "cache at '${SMALLTALK_CI_CACHE}'."
  print_info "builds at '${SMALLTALK_CI_BUILD_BASE}'."
  if is_dir "${SMALLTALK_CI_CACHE}" || \
      is_dir "${SMALLTALK_CI_BUILD_BASE}"; then
    read -p "Are you sure you want to clear builds and cache? (y/N): " user_input
    if [[ "${user_input}" = "y" ]]; then
      clean_up
    fi
  else
    print_notice "Nothing to clean up."
  fi
  first_action="check_cleanup"
}

################################################################################
# Remove all builds and clear cache.
# Globals:
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD_BASE
################################################################################
clean_up() {
  print_info "Cleaning up..."
  print_error "Removing the following directories:"
  if is_dir "${SMALLTALK_CI_CACHE}"; then
    print_info "  ${SMALLTALK_CI_CACHE}"
    rm -rf "${SMALLTALK_CI_CACHE}"
  fi
  if is_dir "${SMALLTALK_CI_BUILD_BASE}"; then
    print_info "  ${SMALLTALK_CI_BUILD_BASE}"
    # Make sure read-only files (e.g. some GemStone files) can be removed
    chmod -fR +w "${SMALLTALK_CI_BUILD_BASE}"
    rm -rf "${SMALLTALK_CI_BUILD_BASE}"
  fi
  print_info "Done."
}

################################################################################
# Load platform-specific package and run the build.
# Locals:
#   config_smalltalk
################################################################################
run() {
  case "${config_smalltalk}" in
    Squeak*)
      print_info "Starting Squeak build..."
      source "${SMALLTALK_CI_HOME}/squeak/run.sh"
      ;;
    Pharo*|Moose*)
      print_info "Starting Pharo build..."
      source "${SMALLTALK_CI_HOME}/pharo/run.sh"
      ;;
    GemStone*)
      print_info "Starting GemStone build..."
      source "${SMALLTALK_CI_HOME}/gemstone/run.sh"
      ;;
    GToolkit*)
      print_info "Starting GToolkit build..."
      source "${SMALLTALK_CI_HOME}/gtoolkit/run.sh"
      ;;
    *)
      print_error_and_exit "Unknown Smalltalk image '${config_smalltalk}'."
      ;;
  esac

  if debug_enabled; then
    fold_start display_config "Current configuration"
      print_config
    fold_end display_config
  fi

  run_build "$@"
}

################################################################################
# Main entry point. Exit with build status code.
# Arguments:
#   All positional parameters
################################################################################
main() {
  local config_clean="false"
  local config_colorful="true"
  local config_debug="false"
  local config_first_arg_or_empty=""
  local config_force_cache="false"
  export config_headless="true"
  local config_image=""
  export config_overwrite_cache="false"
  export config_smalltalk=""
  local config_ston=""
  export config_tracking="true"
  local config_verbose="false"
  local config_vm=""
  local config_vm_dir

  initialize "$@"
  parse_options "$@"
  [[ "${config_verbose}" = "true" ]] && set -o xtrace
  check_clean_up
  ensure_ston_config_exists "${config_first_arg_or_empty}"
  select_smalltalk
  validate_configuration
  set_context_options
  config_vm_dir="${SMALLTALK_CI_VMS}/${config_smalltalk}"
  prepare_folders
  export_coveralls_data
  prepare_environment
  run "$@"
  finalize
}

# Run main if script is not being tested
if [[ "$(basename -- "$0")" != *"test"* ]]; then
  main "$@"
fi
