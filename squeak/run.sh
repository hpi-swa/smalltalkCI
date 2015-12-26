#!/bin/bash

set -e

readonly BASE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts"
readonly VM_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/vms"
readonly IMAGE_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/images"

check_options() {
  is_empty "${baseline_group}" && baseline_group="TravisCI"
  is_empty "${exclude_categories}" && exclude_categories="nil"
  is_empty "${exclude_classes}" && exclude_classes="nil"
  is_empty "${force_update}" && force_update="false"
  is_empty "${keep_open}" && keep_open="false"
  if is_empty "${run_script}"; then
    run_script="${SMALLTALK_CI_HOME}/squeak/run.st"
  else
    run_script="${project_home}/${run_script}"
  fi
  return 0
}

specify_image() {
  case "${smalltalk}" in
    "Squeak-trunk"|"Squeak-Trunk"|"SqueakTrunk")
      readonly image_tar="Squeak-Trunk.tar.gz"
      readonly spur_image=true
      ;;
    "Squeak-5.0"|"Squeak5.0")
      readonly image_tar="Squeak-5.0.tar.gz"
      readonly spur_image=true
      ;;
    "Squeak-4.6"|"Squeak4.6")
      readonly image_tar="Squeak-4.6.tar.gz"
      readonly spur_image=false
      ;;
    "Squeak-4.5"|"Squeak4.5")
      readonly image_tar="Squeak-4.5.tar.gz"
      readonly spur_image=false
      ;;
    *)
      print_error "Unsupported Squeak version '${smalltalk}'."
      exit 1
      ;;
  esac
}

identify_os_and_vm() {
  local cog_vm_file_base

  case "$(uname -s)" in
    "Linux")
      print_info "Linux detected..."
      if [[ "${spur_image}" = true ]]; then
        cog_vm_file_base="cog_linux_spur"
        cog_vm="${SMALLTALK_CI_VMS}/cogspurlinux/bin/squeak"
      else
        cog_vm_file_base="cog_linux"
        cog_vm="${SMALLTALK_CI_VMS}/coglinux/bin/squeak"
      fi
      cog_vm_file="${cog_vm_file_base}.tar.gz"
      if is_travis_build; then
        cog_vm_file="${cog_vm_file_base}.min.tar.gz"
        cog_vm_params=(-nosound -nodisplay)
      fi
      ;;
    "Darwin")
      print_info "OS X detected..."
      if [[ "${spur_image}" = true ]]; then
        cog_vm_file_base="cog_osx_spur"
        cog_vm="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
      else
        cog_vm_file_base="cog_osx"
        cog_vm="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
      fi
      cog_vm_file="${cog_vm_file_base}.tar.gz"
      ;;
    *)
      print_error "Unsupported platform '$(uname -s)'"
      exit 1
      ;;
  esac
}

prepare_vm() {
  local download_url="${VM_DOWNLOAD}/${cog_vm_file}"
  local target="${SMALLTALK_CI_CACHE}/${cog_vm_file}"

  if ! is_file "${target}"; then
    print_timed "Downloading virtual machine..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download virtual machine"
  fi

  if ! is_file "${cog_vm}"; then
    print_info "Extracting virtual machine..."
    tar xzf "${target}" -C "${SMALLTALK_CI_VMS}"
  fi
}

prepare_image() {
  local download_url="${IMAGE_DOWNLOAD}/${image_tar}"
  local target="${SMALLTALK_CI_CACHE}/${image_tar}"

  if ! is_file "${target}"; then
    print_timed "Downloading ${smalltalk} testing image..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download ${smalltalk} testing image"
  fi

  print_info "Extracting image..."
  tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"
}

load_project_and_run_tests() {
  local vm_args

  print_info "Load project into image and run tests..."
  vm_args=(${packages} ${baseline} ${baseline_group} ${exclude_categories} \
      ${exclude_classes} ${force_update} ${keep_open})
  "${cog_vm}" "${cog_vm_params[@]}" "${SMALLTALK_CI_IMAGE}" "${run_script}" \
      "${vm_args[@]}" || exit_status=$?
}

run_build() {
  local image_tar
  local spur_image
  local cog_vm_file
  local cog_vm_params
  local cog_vm

  check_options
  specify_image
  identify_os_and_vm
  prepare_vm
  prepare_image
  load_project_and_run_tests
}
