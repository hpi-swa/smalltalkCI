#!/bin/bash

set -e

source helpers.sh

readonly BUILDER_CI_REPO_URL="https://github.com/dalehenrich/builderCI"
readonly BUILDER_CI_DOWNLOAD_URL="${BUILDER_CI_REPO_URL}/archive/master.zip"

check_os() {
  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error "Unsupported platform '$(uname -s)'"
      exit 1
      ;;
  esac
}

determine_project_home() {
  if is_not_empty "${PROJECT_HOME}"; then
    project_home="${PROJECT_HOME}"
  else
    project_home="${!#}" # Last parameter
  fi

  if ! is_dir "${project_home}"; then
    print_error "Project home is not found."
    exit 1
  fi

  if [[ "${project_home:0:1}" != "/" ]]; then
    project_home="$(cd "${project_home}" && pwd)"
  fi
}

check_env_vars_options() {
  is_not_empty "${BASELINE_GROUP}" \
      && baseline_group="${BASELINE_GROUP}"
  is_not_empty "${PACKAGES}" \
      && packages="${PACKAGES}"
  is_not_empty "${FORCE_UPDATE}" \
      && force_update="${FORCE_UPDATE}"
  is_not_empty "${BUILDERCI}" \
      && builder_ci_fallback="${BUILDERCI}"
  is_not_empty "${RUN_SCRIPT}" \
      && run_script="${RUN_SCRIPT}"
  is_not_empty "${EXCLUDE_CATEGORIES}" \
      && excluded_categories="${EXCLUDE_CATEGORIES}"
  is_not_empty "${EXCLUDE_CLASSES}" \
      && excluded_classes="${EXCLUDE_CLASSES}"
  is_not_empty "${KEEP_OPEN}" \
      && keep_open="${KEEP_OPEN}"
  return 0
}

load_options_from_yml() {
  user_travis_conf="${project_home}/.travis.yml"
  if is_file "${user_travis_conf}"; then
    eval "$(ruby yaml_parser.rb "${user_travis_conf}")"
  else
    print_notice "Could not find '${user_travis_conf}'."
  fi
}

validate_options() {
  if is_empty "${smalltalk}"; then
    print_error "Smalltalk image is not defined."
    exit 1
  fi
  if is_empty "${baseline}"; then
    print_error "Baseline could not be found."
    exit 1
  fi
  if [[ ${packages:0:1} == "/" ]]; then
    packages=${packages:1}
    print_notice "Please remove the leading slash from 'smalltalk_packages'."
  fi
}

check_and_set_paths() {
  if is_empty "${SMALLTALK_CI_HOME}" && ! is_travis_build; then
    export SMALLTALK_CI_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${SMALLTALK_CI_HOME}/env_vars"
  fi
}

parse_args() {
  local user_travis_conf

  if ! is_travis_build && [[ $# -eq 0 ]]; then
    print_help
    exit 0
  fi  

  determine_project_home "$@"
  load_options_from_yml
  check_env_vars_options


  # Handle all arguments and flags
  while :
  do
    case "$1" in
    --baseline)
      baseline="$2"
      shift 2 ;;
    --baseline-group)
      baseline_group="$2"
      shift 2 ;;
    --builder-ci)
      builder_ci_fallback="true"
      shift ;;
    --directory)
      directory="$2"
      shift 2 ;;
    --excluded-categories)
      excluded_categories="$2"
      shift 2 ;;
    --excluded-classes)
      excluded_classes="$2"
      shift 2 ;;
    --force-update)
      force_update="true"
      shift ;;
    -h | --help)
      print_help
      exit 0 ;;
    -o | --keep-open)
      keep_open="true"
      shift ;;
    --script)
      run_script="$2"
      shift 2 ;;
    -s | --smalltalk)
      smalltalk="$2"
      shift 2 ;;
    --)
      shift
      break ;;
    -*)
      print_error "Unknown option: $1"
      exit 1 ;;
    *) 
      break ;;
    esac
  done

  validate_options
  check_and_set_paths
}

fallback_enabled() {
  [[ "${builder_ci_fallback}" == "true" ]] \
      || [[ "${SMALLTALK}" == "GemStone"* ]]
}

builder_ci_fallback() {
  # Make sure the script runs on Linux
  if [[ "$(uname -s)" != "Linux" ]]; then
    print_error "builderCI only supports Linux builds."
    exit 1
  fi
  if is_travis_build; then
    # Make sure the script runs on standard infrastructure
    sudo -n true
    if [[ "$?" != 0 ]]; then
      print_error "sudo is not available."
      exit 1
    fi
  fi

  print_info "Starting legacy build using builderCI..."
  export ST="${SMALLTALK}"
  export PROJECT_HOME="${project_home}"
  cd "${HOME}"
  wget -q -O builderCI.zip "${BUILDER_CI_DOWNLOAD_URL}"
  unzip -q builderCI.zip
  cd builderCI-*
  source build_env_vars
  ln -s "${PROJECT_HOME}" "${GIT_PATH}"
  print_info "builderCI: Build image..."
  ./build_image.sh
  print_info "builderCI: Run tests..."
  "$BUILDER_CI_HOME/testTravisCI.sh" -verbose || exit_status=$?
}

prepare_folders() {
  print_info "Preparing folders..."
  is_dir "${SMALLTALK_CI_CACHE}" || mkdir "${SMALLTALK_CI_CACHE}"
  is_dir "${SMALLTALK_CI_BUILD_BASE}" || mkdir "${SMALLTALK_CI_BUILD_BASE}"
  is_dir "${SMALLTALK_CI_VMS}" || mkdir "${SMALLTALK_CI_VMS}"
  # Create folder for this build (should not exist)
  mkdir "${SMALLTALK_CI_BUILD}"
  # Link project folder to git_cache
  ln -s "${project_home}" "${SMALLTALK_CI_GIT}"
}

run() {
  case "${smalltalk}" in
    Squeak*)
      print_info "Starting Squeak build..."
      source "${SMALLTALK_CI_HOME}/squeak/run.sh"
      ;;
    Pharo*)
      print_info "Starting Pharo build..."
      source "${SMALLTALK_CI_HOME}/pharo/run.sh"
      ;;
    *)
      print_error "Unknown Smalltalk version '${smalltalk}'."
      exit 1
      ;;
  esac

  run_build
}

check_exit_status() {
  printf "\n\n"
  if [[ ${exit_status} -eq 0 ]]; then
    print_success "Build successful :)"
  else
    print_error "Build failed :("
    if is_travis_build; then
      print_info "\n\nTo reproduce the failed build locally, download
        smalltalkCI and try running something like:"
      print_notice "\n./run.sh --keep-open /path/to/your/project"
    fi
  fi
  printf "\n"
}

main() {
  local smalltalk=${SMALLTALK}
  local project_home
  local baseline
  local baseline_group
  local packages="packages"
  local force_update
  local builder_ci_fallback="false"
  local run_script
  local excluded_categories
  local excluded_classes
  local keep_open="false"
  local exit_status=0

  check_os
  parse_args "$@"

  if fallback_enabled; then
    builder_ci_fallback
  else
    prepare_folders
    run
  fi
  
  check_exit_status
  exit ${exit_status}
}

if [[ "$(basename -- "$0")" == "run.sh" ]]; then
  main "$@"
fi
