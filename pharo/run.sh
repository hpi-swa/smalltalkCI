#!/bin/bash

set -e

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   config_baseline_group
#   config_directory
#   config_tests
# Returns:
#   0
################################################################################
pharo::check_options() {
  is_empty "${config_baseline_group}" && config_baseline_group="default"
  is_empty "${config_directory}" && config_directory=""
  is_empty "${config_tests}" && config_tests="${config_baseline}.*"
  return 0
}

################################################################################
# Select Pharo image download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   Pharo image download url
################################################################################
pharo::get_image_url() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    "Pharo-alpha")
      echo "get.pharo.org/alpha"
      ;;
    "Pharo-stable")
      echo "get.pharo.org/stable"
      ;;
    "Pharo-5.0")
      echo "get.pharo.org/50"
      ;;
    "Pharo-4.0")
      echo "get.pharo.org/40"
      ;;
    "Pharo-3.0")
      echo "get.pharo.org/30"
      ;;
    *)
      print_error "Unsupported Pharo version '${smalltalk_name}'."
      exit 1
      ;;
  esac
}

################################################################################
# Select Pharo vm download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   Pharo vm download url
################################################################################
pharo::get_vm_url() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    "Pharo-alpha")
      echo "get.pharo.org/vm50"
      ;;
    "Pharo-stable")
      echo "get.pharo.org/vm40"
      ;;
    "Pharo-5.0")
      echo "get.pharo.org/vm50"
      ;;
    "Pharo-4.0")
      echo "get.pharo.org/vm40"
      ;;
    "Pharo-3.0")
      echo "get.pharo.org/vm30"
      ;;
    *)
      print_error "Unsupported Pharo version '${smalltalk_name}'."
      exit 1
      ;;
  esac
}

################################################################################
# Download and move vm if necessary.
# Locals:
#   config_keep_open
# Globals:
#   SMALLTALK_CI_VM
# Arguments:
#   smalltalk_name
################################################################################
pharo::prepare_vm() {
  local smalltalk_name=$1
  local pharo_vm_url="$(pharo::get_vm_url "${smalltalk_name}")"
  local pharo_vm_folder="${SMALLTALK_CI_VMS}/${smalltalk_name}"

  if [[ "${config_keep_open}" = "true" ]]; then
    export SMALLTALK_CI_VM="${pharo_vm_folder}/pharo-ui"
  else
    export SMALLTALK_CI_VM="${pharo_vm_folder}/pharo"
  fi

  if ! is_dir "${pharo_vm_folder}"; then
    print_timed "Downloading ${smalltalk_name} vm..."
    mkdir "${pharo_vm_folder}"
    pushd "${pharo_vm_folder}" > /dev/null
    download_file "${pharo_vm_url}" | bash
    popd > /dev/null
    print_timed_result "Time to download ${smalltalk_name} vm"

    if ! is_file "${SMALLTALK_CI_VM}"; then
      print_error "Unable to set up virtual machine at '${SMALLTALK_CI_VM}'."
      exit 1
    fi
  fi
}

################################################################################
# Download image if necessary and copy it to build folder.
# Globals:
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_CACHE
# Arguments:
#   smalltalk_name
################################################################################
pharo::prepare_image() {
  local smalltalk_name=$1
  local pharo_image_url="$(pharo::get_image_url "${smalltalk_name}")"
  local pharo_image_file="${smalltalk_name}.image"
  local pharo_changes_file="${smalltalk_name}.changes"

  if ! is_file "${SMALLTALK_CI_CACHE}/${pharo_image_file}"; then
    print_timed "Downloading ${smalltalk_name} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null
    download_file "${pharo_image_url}" | bash
    mv "Pharo.image" "${pharo_image_file}"
    mv "Pharo.changes" "${pharo_changes_file}"
    popd > /dev/null
    print_timed_result "Time to download ${smalltalk_name} image"
  fi

  print_info "Preparing image..."
  cp "${SMALLTALK_CI_CACHE}/${pharo_image_file}" "${SMALLTALK_CI_IMAGE}"
  cp "${SMALLTALK_CI_CACHE}/${pharo_changes_file}" "${SMALLTALK_CI_CHANGES}"
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
################################################################################
pharo::load_project() {
  print_info "Loading project..."
  "${SMALLTALK_CI_VM}" "${SMALLTALK_CI_IMAGE}" eval --save "
  Metacello new 
    baseline: '${config_baseline}';
    repository: 'filetree://${config_project_home}/${config_directory}';
    load: '${config_baseline_group}'.
  "
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
  pharo::check_options
  pharo::prepare_image "${config_smalltalk}"
  pharo::prepare_vm "${config_smalltalk}"
  pharo::load_project

  pharo::run_tests "${config_tests}"
  return $?
}
