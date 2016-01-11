#!/bin/bash

set -e

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   config_baseline_group
#   config_directory
#   config_tests
################################################################################
pharo::check_options() {
  is_empty "${config_baseline_group}" && config_baseline_group="default"
  is_empty "${config_directory}" && config_directory=""
  if is_empty "${config_tests}"; then
    ! is_empty "${config_baseline}" && config_tests="${config_baseline}.*"
    ! is_empty "${config_configuration}" && config_tests="${config_configuration}.*"
  fi
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
      print_error_and_exit "Unsupported Pharo version '${smalltalk_name}'."
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
      print_error_and_exit "Unsupported Pharo version '${smalltalk_name}'."
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
#   headful: 'true' for headful, 'false' for headless mode
################################################################################
pharo::prepare_vm() {
  local smalltalk_name=$1
  local headful=$2
  local pharo_vm_url="$(pharo::get_vm_url "${smalltalk_name}")"
  local pharo_vm_folder="${SMALLTALK_CI_VMS}/${smalltalk_name}"
  local pharo_zeroconf

  if [[ "${headful}" = "true" ]]; then
    export SMALLTALK_CI_VM="${pharo_vm_folder}/pharo-ui"
  else
    export SMALLTALK_CI_VM="${pharo_vm_folder}/pharo"
  fi

  if ! is_dir "${pharo_vm_folder}"; then
    print_timed "Downloading ${smalltalk_name} vm..."
    mkdir "${pharo_vm_folder}"
    pushd "${pharo_vm_folder}" > /dev/null

    set +e
    pharo_zeroconf="$(download_file "${pharo_vm_url}")"
    if [[ ! $? -eq 0 ]]; then
      print_error_and_exit "Download failed."
    fi
    set -e

    # Execute Pharo Zeroconf Script
    bash -c "${pharo_zeroconf}"

    popd > /dev/null
    print_timed_result "Time to download ${smalltalk_name} vm"

    if ! is_file "${SMALLTALK_CI_VM}"; then
      print_error_and_exit "Unable to set vm up at '${SMALLTALK_CI_VM}'."
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
  local pharo_zeroconf

  if ! is_file "${SMALLTALK_CI_CACHE}/${pharo_image_file}"; then
    print_timed "Downloading ${smalltalk_name} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null

    set +e
    pharo_zeroconf="$(download_file "${pharo_image_url}")"
    if [[ ! $? -eq 0 ]]; then
      print_error_and_exit "Download failed."
    fi
    set -e

    # Execute Pharo Zeroconf Script
    bash -c "${pharo_zeroconf}"

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
#   config_configuration
#   config_configuration_version
#   config_directory
#   config_project_home
# Globals:
#   SMALLTALK_CI_VM
#   SMALLTALK_CI_IMAGE
# Returns:
#   Status code of project loading
################################################################################
pharo::load_and_test_project() {
  print_info "Loading and testing project..."
  "${SMALLTALK_CI_VM}" "${SMALLTALK_CI_IMAGE}" eval --save "
  | stream |
  stream := '${SMALLTALK_CI_HOME}/lib/SmalltalkCI-Core.st'.
  stream := StandardFileStream oldFileNamed: stream.
  stream := MultiByteFileStream newFrom: stream.
  stream fileIn.
  stream close.
  SCISpec automatedTestOf: '${config_project_home}/smalltalk.ston'
  "
}

################################################################################
# Main entry point for Pharo builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local exit_status=0

  pharo::check_options
  pharo::prepare_image "${config_smalltalk}"
  pharo::prepare_vm "${config_smalltalk}" "${config_keep_open}"

  pharo::load_and_test_project || exit_status=$?

  print_junit_xml "${SMALLTALK_CI_BUILD}"

  return "${exit_status}"
}
