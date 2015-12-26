#!/bin/bash

set -e

readonly PHARO_IMAGE="${SMALLTALK}.image"
readonly PHARO_CHANGES="${SMALLTALK}.changes"
if [[ "${keep_open}" = "true" ]]; then
  readonly PHARO_VM="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo-ui"
else
  readonly PHARO_VM="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo"
fi

set_download_urls() {
  case "${SMALLTALK}" in
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
      print_error "Unsupported Pharo version '${SMALLTALK}'"
      exit 1
      ;;
  esac
}

check_options() {
  is_empty "${baseline_group}" && baseline_group="default"
  is_empty "${packages}" && packages=""
  is_empty "${tests}" && tests="${baseline}.*"
  return 0
}

download_image() {
  if ! is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}"; then
    print_timed "Downloading ${SMALLTALK} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null
    download_file "get.pharo.org/${pharo_get_image}" | bash
    mv Pharo.image "${SMALLTALK}.image"
    mv Pharo.changes "${SMALLTALK}.changes"
    popd > /dev/null
    print_timed_result "Time to download ${SMALLTALK} image"
  fi
}

download_vm() {
  if ! is_dir "${SMALLTALK_CI_VMS}/${SMALLTALK}"; then
    print_timed "Downloading ${SMALLTALK} vm..."
    mkdir "${SMALLTALK_CI_VMS}/${SMALLTALK}"
    pushd "${SMALLTALK_CI_VMS}/${SMALLTALK}" > /dev/null
    download_file "get.pharo.org/${pharo_get_vm}" | bash
    popd > /dev/null
    # Make sure vm is now available
    [[ is_file "${PHARO_VM}" ]] || exit 1
    print_timed_result "Time to download ${SMALLTALK} vm"
  fi
}

prepare_image() {
  print_info "Preparing image..."
  cp "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}" "${SMALLTALK_CI_BUILD}"
  cp "${SMALLTALK_CI_CACHE}/${PHARO_CHANGES}" "${SMALLTALK_CI_BUILD}"
}

load_project() {
  print_info "Loading project..."
  "${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" eval --save "
  Metacello new 
    baseline: '${baseline}';
    repository: 'filetree://${project_home}/${packages}';
    load: '${baseline_group}'.
  "
}

run_tests() {
  print_info "Run tests..."
  "${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" test --junit-xml-output \
      --fail-on-failure "${tests}" 2>&1 || exit_status=$?
}

run_build() {
  set_download_urls
  check_options
  download_image
  download_vm
  prepare_image
  load_project
  run_tests
}