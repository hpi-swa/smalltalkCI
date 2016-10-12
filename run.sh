#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly DEFAULT_STON_CONFIG="smalltalk.ston"
readonly BUILD_STATUS_FILE="build_status.txt"
readonly INSTALL_TARGET_OSX="/usr/local/bin"
readonly BINTRAY_API="https://api.bintray.com/content"

################################################################################
# Determine $SMALLTALK_CI_HOME and load helpers.
################################################################################
initialize() {
  local resolved_path

  trap interrupted INT

  # Fail if OS is not supported
  case "$(uname -s)" in
    "Linux"|"Darwin"|"CYGWIN_NT-"*)
      ;;
    *)
      echo "Unsupported platform '$(uname -s)'." 1>&2
      exit 1
      ;;
  esac

  if [[ -z "${SMALLTALK_CI_HOME:-}" ]]; then
    # Try to determine absolute path to smalltalkCI
    SMALLTALK_CI_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
}

################################################################################
# Print notice on interrupt.
################################################################################
interrupted() {
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
  if ! is_empty "${custom_ston}" && [[ ${custom_ston: -5} == ".ston" ]] && \
      is_file "${custom_ston}"; then
    config_ston="${custom_ston}"
    # Expand path if $config_ston does not start with / or ~
    if ! [[ "${config_ston:0:1}" =~ (\/|\~) ]]; then
      config_ston="$(pwd)/${config_ston}"
    fi
    return
  fi

  if is_travis_build; then
    if is_not_empty "${TRAVIS_SMALLTALK_CONFIG:-}"; then
      config_ston="${TRAVIS_BUILD_DIR}/${TRAVIS_SMALLTALK_CONFIG}"
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

  if ! is_file "${config_ston}"; then
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
  local images="Squeak-trunk Squeak-5.1 Squeak-5.0 Squeak-4.6 Squeak-4.5
                Pharo-stable Pharo-alpha Pharo-6.0 Pharo-5.0 Pharo-4.0 Pharo-3.0
                GemStone-3.3.0 GemStone-3.2.12 GemStone-3.1.0.6
                Moose-trunk Moose-6.1 Moose-6.0"

  if is_travis_build || is_appveyor_build; then
    config_smalltalk="${TRAVIS_SMALLTALK_VERSION:-${SMALLTALK}}"
    return
  fi

  # Ask user to choose an image if one has not been selected yet
  if is_empty "${config_smalltalk}"; then
    PS3="Choose Smalltalk image: "
    select selection in $images; do
      case "${selection}" in
        Squeak*|Pharo*|GemStone*|Moose*)
          config_smalltalk="${selection}"
          break
          ;;
        *)
          print_error_and_exit "No Smalltalk image selected."
          ;;
      esac
    done
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
  if is_empty "${config_ston}"; then
    print_error_and_exit "No STON file found."
  elif ! is_file "${config_ston}"; then
    print_error_and_exit "STON file at '${config_ston}' does not exist."
  fi
}

################################################################################
# Handle user-defined options.
# Locals:
#   config_clean
#   config_debug
#   config_headless
#   config_smalltalk
#   config_verbose
# Arguments:
#   All positional parameters
################################################################################
parse_options() {
  while :
  do
    case "${1:-}" in
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
    --headfull)
      config_headless="false"
      shift
      ;;
    --install)
      install_script
      exit 0
      ;;
    -s | --smalltalk)
      config_smalltalk="${2:-}"
      shift 2
      ;;
    --uninstall)
      uninstall_script
      exit 0
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
}

################################################################################
# Make sure all required folders exist, create build folder and symlink project.
# Locals:
#   config_ston
# Globals:
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD_BASE
#   SMALLTALK_CI_VMS
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_GIT
################################################################################
prepare_folders() {
  local project_home

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
  project_home="$(dirname "${config_ston}")"
  ln -s "${project_home}" "${SMALLTALK_CI_GIT}"
}

################################################################################
# Add environment variables for in-image use (with `SCIII_` prefix).
################################################################################
add_env_vars() {
  export SCIII_SMALLTALK="${config_smalltalk}"
  export SCIII_BUILD="$(resolve_path "${SMALLTALK_CI_BUILD}")"
}

################################################################################
# Check build status and exit with non-zero exit code if necessary.
# Locals:
#   build_status
# Globals:
#   SMALLTALK_CI_BUILD
################################################################################
check_build_status() {
  local build_status

  if ! is_file "${SMALLTALK_CI_BUILD}/${BUILD_STATUS_FILE}"; then
    print_error_and_exit "Build failed before tests were performed correctly."
  fi
  build_status=$(cat "${SMALLTALK_CI_BUILD}/${BUILD_STATUS_FILE}")
  if is_nonzero "${build_status}"; then
    exit 1
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
  local question2="Continue with build progress? (y/N): "
  if [[ "${config_clean}" = "true" ]]; then
    print_info "cache at '${SMALLTALK_CI_CACHE}'."
    print_info "builds at '${SMALLTALK_CI_BUILD_BASE}'."
    if is_dir "${SMALLTALK_CI_CACHE}" || \
        is_dir "${SMALLTALK_CI_BUILD_BASE}"; then
      read -p "${question1}" user_input
      if [[ "${user_input}" = "y" ]]; then
        clean_up
      fi
    else
      print_notice "Nothing to clean up."
    fi
    if is_empty "${config_smalltalk}" || is_empty "${config_ston}"; then
      exit  # User did not supply enough arguments to continue
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
# Install 'smalltalkCI' command by symlinking current instance.
# Globals:
#   INSTALL_TARGET_OSX
################################################################################
install_script() {
  local target

  case "$(uname -s)" in
    "Linux")
      print_notice "Not yet implemented."
      ;;
    "Darwin")
      target="${INSTALL_TARGET_OSX}"
      if ! is_dir "${target}"; then
        local message = "'${target}' does not exist. Do you want to create it?
                         (y/N): "
        read -p "${message}" user_input
        if [[ "${user_input}" = "y" ]]; then
          sudo mkdir "target"
        else
          print_error_and_exit "'${target}' has not been created."
        fi
      fi
      if ! is_file "${target}/smalltalkCI"; then
        ln -s "${SMALLTALK_CI_HOME}/run.sh" "${target}/smalltalkCI"
        print_info "The command 'smalltalkCI' has been installed successfully."
      else
        print_error_and_exit "'${target}/smalltalkCI' already exists."
      fi
      ;;
  esac
}

################################################################################
# Uninstall 'smalltalkCI' command by removing any symlink to smalltalkCI.
# Globals:
#   INSTALL_TARGET_OSX
################################################################################
uninstall_script() {
  local target

  case "$(uname -s)" in
    "Linux")
      print_notice "Not yet implemented."
      ;;
    "Darwin")
      target="${INSTALL_TARGET_OSX}"
      if is_file "${target}/smalltalkCI"; then
        rm -f "${target}/smalltalkCI"
        print_info "The command 'smalltalkCI' has been uninstalled
                    successfully."
      else
        print_error_and_exit "'${target}/smalltalkCI' does not exists."
      fi
      ;;
  esac
}

################################################################################
# Deploy build artifacts to bintray if configured.
################################################################################
deploy() {
  local build_status=$1
  local target
  local version="${TRAVIS_BUILD_NUMBER}"
  local project_name="$(basename ${TRAVIS_BUILD_DIR})"
  local name="${project_name}-${TRAVIS_JOB_NUMBER}-${config_smalltalk}"
  local image_name="${SMALLTALK_CI_BUILD}/${name}.image"
  local changes_name="${SMALLTALK_CI_BUILD}/${name}.changes"
  local publish=false

  if is_empty "${BINTRAY_CREDENTIALS:-}" || \
      [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    return
  fi

  if [[ "${build_status}" -eq 0 ]]; then
    if is_empty "${BINTRAY_RELEASE:-}" || \
        [[ "${TRAVIS_BRANCH}" != "master" ]]; then
      return
    fi
    target="${BINTRAY_API}/${BINTRAY_RELEASE}/${version}"
    publish=true
  else
    if is_empty "${BINTRAY_FAIL:-}"; then
      return
    fi
    target="${BINTRAY_API}/${BINTRAY_FAIL}/${version}"
  fi

  travis_fold start deploy "Deploying to bintray.com..."
    timer_start

    pushd "${SMALLTALK_CI_BUILD}" > /dev/null

    print_info "Compressing and uploading image and changes files..."
    mv "${SMALLTALK_CI_IMAGE}" "${name}.image"
    mv "${SMALLTALK_CI_CHANGES}" "${name}.changes"
    tar czf "${name}.tar.gz" "${name}.image" "${name}.changes"
    curl -s -u "$BINTRAY_CREDENTIALS" -T "${name}.tar.gz" \
        "${target}/${name}.tar.gz" > /dev/null
    zip -q "${name}.zip" "${name}.image" "${name}.changes"
    curl -s -u "$BINTRAY_CREDENTIALS" -T "${name}.zip" \
        "${target}/${name}.zip" > /dev/null

    if [[ "${build_status}" -ne 0 ]]; then
      # Check for xml files and upload them
      if ls *.xml 1> /dev/null 2>&1; then
        print_info "Compressing and uploading debugging files..."
        mv "${TRAVIS_BUILD_DIR}/"*.fuel "${SMALLTALK_CI_BUILD}/" || true
        find . -name "*.xml" -o -name "*.fuel" | tar czf "debug.tar.gz" -T -
        curl -s -u "$BINTRAY_CREDENTIALS" \
            -T "debug.tar.gz" "${target}/" > /dev/null
      fi
    fi

    if "${publish}"; then
      print_info "Publishing ${version}..."
      curl -s -X POST -u "$BINTRAY_CREDENTIALS" "${target}/publish" > /dev/null
    fi

    popd > /dev/null

    timer_finish
  travis_fold end deploy
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

  run_build "$@"
}

################################################################################
# Main entry point. Exit with build status code.
# Arguments:
#   All positional parameters
################################################################################
main() {
  local config_smalltalk=""
  local config_ston=""
  local config_clean="false"
  local config_debug="false"
  local config_headless="true"
  local config_verbose="false"
  local status=0

  initialize
  parse_options "$@"
  [[ "${config_verbose}" = "true" ]] && set -o xtrace
  ensure_ston_config_exists "${!#}"  # Use last argument for custom STON
  check_clean_up
  select_smalltalk
  validate_configuration
  prepare_folders
  export_coveralls_data
  add_env_vars

  run "$@" || status=$?

  if is_travis_build || is_appveyor_build; then
    upload_coverage_results
  fi

  if is_travis_build; then
    deploy "${status}"
  fi

  check_build_status
}

# Run main if script is not being tested
if [[ "$(basename -- "$0")" != *"test"* ]]; then
  main "$@"
fi
