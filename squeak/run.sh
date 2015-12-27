#!/bin/bash

set -e

readonly BASE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts"
readonly VM_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/vms"
readonly IMAGE_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/images"

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   baseline_group
#   exclude_categories
#   exclude_classes
#   force_update
#   keep_open
#   run_script
#   project_home
# Globals:
#   SMALLTALK_CI_HOME
# Returns:
#   0
################################################################################
squeak::check_options() {
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

################################################################################
# Select vm according to build environment. Exit with '1' if environtment is not
# supported.
# Locals:
#   cog_vm
#   cog_vm_file
#   cog_vm_params
# Globals:
#   SMALLTALK_CI_VMS
# Arguments:
#   'true' for Spur vm, 'false' for non-Spur vm
################################################################################
squeak::select_vm() {
  local requires_spur_vm=$1
  local cog_vm_file_base

  case "$(uname -s)" in
    "Linux")
      print_info "Linux detected..."
      if [[ "${requires_spur_vm}" = "true" ]]; then
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
      if [[ "${requires_spur_vm}" = "true" ]]; then
        cog_vm_file_base="cog_osx_spur"
        cog_vm="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
      else
        cog_vm_file_base="cog_osx"
        cog_vm="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
      fi
      cog_vm_file="${cog_vm_file_base}.tar.gz"
      ;;
    *)
      print_error "Unsupported platform '$(uname -s)'."
      exit 1
      ;;
  esac
}

################################################################################
# Select Squeak image. Exit with '1' if image_name is unsupported.
# Arguments:
#   Smalltalk image name
################################################################################
squeak::select_image() {
  local image_name=$1

  case "${image_name}" in
    "Squeak-trunk"|"Squeak-Trunk"|"SqueakTrunk")
      readonly image_tar="Squeak-Trunk.tar.gz"
      readonly requires_spur_vm=true
      ;;
    "Squeak-5.0"|"Squeak5.0")
      readonly image_tar="Squeak-5.0.tar.gz"
      readonly requires_spur_vm=true
      ;;
    "Squeak-4.6"|"Squeak4.6")
      readonly image_tar="Squeak-4.6.tar.gz"
      readonly requires_spur_vm=false
      ;;
    "Squeak-4.5"|"Squeak4.5")
      readonly image_tar="Squeak-4.5.tar.gz"
      readonly requires_spur_vm=false
      ;;
    *)
      print_error "Unsupported Squeak version '${image_name}'."
      exit 1
      ;;
  esac
}

################################################################################
# Download and extract vm if necessary.
# Globals:
#   VM_DOWNLOAD
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_VMS
# Arguments:
#   cog_vm_file
################################################################################
squeak::prepare_vm() {
  local cog_vm_file=$1
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

################################################################################
# Download image if necessary and extract it.
# Globals:
#   IMAGE_DOWNLOAD
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD
# Arguments:
#   image_file
################################################################################
squeak::prepare_image() {
  local image_file=$1
  local download_url="${IMAGE_DOWNLOAD}/${image_file}"
  local target="${SMALLTALK_CI_CACHE}/${image_file}"

  if ! is_file "${target}"; then
    print_timed "Downloading ${smalltalk} testing image..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download ${smalltalk} testing image"
  fi

  print_info "Extracting image..."
  tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"
}

################################################################################
# Load project and run tests.
# Locals:
#   directory
#   baseline
#   baseline_group
#   exclude_categories
#   exclude_classes
#   force_update
#   keep_open
#   cog_vm
#   cog_vm_params
#   run_script
#   vm_args
# Globals:
#   SMALLTALK_CI_IMAGE
# Returns:
#   Status code of build
################################################################################
squeak::load_project_and_run_tests() {
  local vm_args

  print_info "Load project into image and run tests..."
  vm_args=(${directory} ${baseline} ${baseline_group} ${exclude_categories} \
      ${exclude_classes} ${force_update} ${keep_open})
  "${cog_vm}" "${cog_vm_params[@]}" "${SMALLTALK_CI_IMAGE}" "${run_script}" \
      "${vm_args[@]}"
  return $?
}

################################################################################
# Main entry point for Squeak builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  local image_tar
  local requires_spur_vm
  local cog_vm_file
  local cog_vm_params=()
  local cog_vm

  squeak::check_options
  squeak::select_image "${smalltalk}"
  squeak::select_vm "${requires_spur_vm}"
  squeak::prepare_vm "${cog_vm_file}"
  squeak::prepare_image "${image_tar}"

  squeak::load_project_and_run_tests
  return $?
}
