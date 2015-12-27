#!/bin/bash

set -e

readonly PHARO_IMAGE="${smalltalk}.image"
readonly PHARO_CHANGES="${smalltalk}.changes"
readonly PHARO_VM_FOLDER="${SMALLTALK_CI_VMS}/${smalltalk}"
if [[ "${keep_open}" = "true" ]]; then
  readonly PHARO_VM="${PHARO_VM_FOLDER}/pharo-ui"
else
  readonly PHARO_VM="${PHARO_VM_FOLDER}/pharo"
fi

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   baseline_group
#   directory
#   tests
# Returns:
#   0
################################################################################
pharo::check_options() {
  is_empty "${baseline_group}" && baseline_group="default"
  is_empty "${directory}" && directory=""
  is_empty "${tests}" && tests="${baseline}.*"
  return 0
}

################################################################################
# Select Pharo download urls for image & vm. Exit if image_name is unsupported.
# Arguments:
#   Smalltalk image name
################################################################################
pharo::set_download_urls() {
  local image_name=$1

  case "${image_name}" in
    "Pharo-alpha")
      readonly pharo_get_image="alpha"
      readonly pharo_get_vm="vm50"
      ;;
    "Pharo-stable")
      readonly pharo_get_image="stable"
      readonly pharo_get_vm="vm40"
      ;;
    "Pharo-5.0")
      readonly pharo_get_image="50"
      readonly pharo_get_vm="vm50"
      ;;
    "Pharo-4.0")
      readonly pharo_get_image="40"
      readonly pharo_get_vm="vm40"
      ;;
    "Pharo-3.0")
      readonly pharo_get_image="30"
      readonly pharo_get_vm="vm30"
      ;;
    *)
      print_error "Unsupported Pharo version '${smalltalk}'"
      exit 1
      ;;
  esac
}

################################################################################
# Download and move vm if necessary.
# Globals:
#   PHARO_VM_FOLDER
#   PHARO_VM
# Arguments:
#   None
################################################################################
pharo::prepare_vm() {
  if ! is_dir "${PHARO_VM_FOLDER}"; then
    print_timed "Downloading ${smalltalk} vm..."
    mkdir "${PHARO_VM_FOLDER}"
    pushd "${PHARO_VM_FOLDER}" > /dev/null
    download_file "get.pharo.org/${pharo_get_vm}" | bash
    popd > /dev/null
    # Make sure vm is now available
    is_file "${PHARO_VM}" || exit 1
    print_timed_result "Time to download ${smalltalk} vm"
  fi
}

################################################################################
# Download image if necessary and copy it to build folder.
# Globals:
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_CACHE
################################################################################
pharo::prepare_image() {
  if ! is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}"; then
    print_timed "Downloading ${smalltalk} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null
    download_file "get.pharo.org/${pharo_get_image}" | bash
    mv "Pharo.image" "${PHARO_IMAGE}"
    mv "Pharo.changes" "${PHARO_CHANGES}"
    popd > /dev/null
    print_timed_result "Time to download ${smalltalk} image"
  fi

  print_info "Preparing image..."
  cp "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}" "${SMALLTALK_CI_BUILD}"
  cp "${SMALLTALK_CI_CACHE}/${PHARO_CHANGES}" "${SMALLTALK_CI_BUILD}"
}

################################################################################
# Load project into Pharo image.
# Locals:
#   baseline
#   project_home
#   baseline_group
# Globals:
#   SMALLTALK_CI_BUILD
#   PHARO_IMAGE
#   PHARO_VM
################################################################################
pharo::load_project() {
  print_info "Loading project..."
  "${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" eval --save "
  Metacello new 
    baseline: '${baseline}';
    repository: 'filetree://${project_home}/${directory}';
    load: '${baseline_group}'.
  "
}

################################################################################
# Run tests in Pharo image.
# Globals:
#   SMALLTALK_CI_BUILD
#   PHARO_IMAGE
#   PHARO_VM
# Arguments:
#   String matching a package name to test
# Returns:
#   Status code of build
################################################################################
pharo::run_tests() {
  local tests=$1

  print_info "Run tests..."
  "${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" test --junit-xml-output \
      --fail-on-failure "${tests}" 2>&1
  return $?
}

################################################################################
# Main entry point for Pharo builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local pharo_get_image
  local pharo_get_vm

  pharo::check_options
  pharo::set_download_urls "${smalltalk}"
  pharo::prepare_vm
  pharo::prepare_image
  pharo::load_project

  pharo::run_tests "$tests"
  return $?
}
