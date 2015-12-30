#!/bin/bash

set -e

readonly BASE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts"
readonly IMAGE_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/images"
readonly VM_DOWNLOAD="http://mirandabanda.org/files/Cog/VM/VM.r3427"

################################################################################
# Check options and set defaults if unavailable.
# Locals:
#   config_baseline_group
#   config_exclude_categories
#   config_exclude_classes
#   config_force_update
#   config_keep_open
#   config_run_script
#   config_project_home
# Globals:
#   SMALLTALK_CI_HOME
# Returns:
#   0
################################################################################
squeak::check_options() {
  is_empty "${config_baseline_group}" && config_baseline_group="TravisCI"
  is_empty "${config_exclude_categories}" && config_exclude_categories="nil"
  is_empty "${config_exclude_classes}" && config_exclude_classes="nil"
  is_empty "${config_force_update}" && config_force_update="false"
  is_empty "${config_keep_open}" && config_keep_open="false"
  if is_empty "${config_run_script}"; then
    config_run_script="${SMALLTALK_CI_HOME}/squeak/run.st"
  else
    config_run_script="${config_project_home}/${config_run_script}"
  fi
  return 0
}

################################################################################
# Select Squeak image. Exit with '1' if smalltalk_name is unsupported.
# Arguments:
#   Smalltalk image name
# Returns:
#   Image filename string
################################################################################
squeak::get_image_filename() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    "Squeak-trunk"|"Squeak-Trunk"|"SqueakTrunk")
      echo "Squeak-Trunk.tar.gz"
      ;;
    "Squeak-5.0"|"Squeak5.0")
      echo "Squeak-5.0.tar.gz"
      ;;
    "Squeak-4.6"|"Squeak4.6")
      echo "Squeak-4.6.tar.gz"
      ;;
    "Squeak-4.5"|"Squeak4.5")
      echo "Squeak-4.5.tar.gz"
      ;;
    *)
      print_error "Unsupported Squeak version '${smalltalk_name}'."
      exit 1
      ;;
  esac
}

################################################################################
# Download image if necessary and extract it.
# Globals:
#   IMAGE_DOWNLOAD
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_IMAGE
# Arguments:
#   smalltalk_name
################################################################################
squeak::prepare_image() {
  local smalltalk_name=$1
  local image_filename
  local download_url
  local target

  image_filename=$(squeak::get_image_filename "${smalltalk_name}")
  download_url="${IMAGE_DOWNLOAD}/${image_filename}"
  target="${SMALLTALK_CI_CACHE}/${image_filename}"

  if ! is_file "${target}"; then
    print_timed "Downloading ${smalltalk_name} testing image..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download ${smalltalk_name} testing image"
  fi

  print_info "Extracting image..."
  tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error "Unable to prepare image at '${SMALLTALK_CI_IMAGE}'."
    exit 1
  fi
}

################################################################################
# Get vm filename and path according to build environment. Exit with '1' if
# environment is not supported.
# Globals:
#   SMALLTALK_CI_IMAGE
# Arguments:
#   os_name
#   require_spur: '1' for Spur support
# Returns:
#   'vm_filename|vm_path' string
################################################################################
squeak::get_vm_details() {
  local os_name=$1
  local require_spur=$2
  local vm_filename
  local vm_path

  case "${os_name}" in
    "Linux")
      if [[ "$require_spur" -eq 1 ]]; then
        vm_filename="cogspurlinux-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/cogspurlinux/bin/squeak"
      else
        vm_filename="coglinux-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/coglinux/bin/squeak"
      fi
      ;;
    "Darwin")
      if [[ "$require_spur" -eq 1 ]]; then
        vm_filename="CogSpur.app-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
      else
        vm_filename="Cog.app-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
      fi
      ;;
    *)
      print_error "Unsupported platform '${os_name}'."
      exit 1
      ;;
  esac

  return_vars "${vm_filename}" "${vm_path}"
}

################################################################################
# Download and extract vm if necessary.
# Globals:
#   VM_DOWNLOAD
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_VMS
################################################################################
squeak::prepare_vm() {
  local require_spur=0
  local vm_details
  local vm_filename
  local vm_path
  local download_url
  local target

  is_spur_image "${SMALLTALK_CI_IMAGE}" && require_spur=1
  vm_details=$(squeak::get_vm_details "$(uname -s)" "${require_spur}")
  set_vars vm_filename vm_path "${vm_details}"
  download_url="${VM_DOWNLOAD}/${vm_filename}"
  target="${SMALLTALK_CI_CACHE}/${vm_filename}"

  export SMALLTALK_CI_VM="${vm_path}"

  if ! is_file "${target}"; then
    print_timed "Downloading virtual machine..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download virtual machine"
  fi

  if ! is_file "${SMALLTALK_CI_VM}"; then
    print_info "Extracting virtual machine..."
    tar xzf "${target}" -C "${SMALLTALK_CI_VMS}"
    if ! is_file "${SMALLTALK_CI_VM}"; then
      print_error "Unable to set up virtual machine at '${SMALLTALK_CI_VM}'."
      exit 1
    fi
  fi

  print_info "Cog VM Information:"
  "${SMALLTALK_CI_VM}" -version
}

################################################################################
# Load project and run tests.
# Locals:
#   config_directory
#   config_baseline
#   config_baseline_group
#   config_exclude_categories
#   config_exclude_classes
#   config_force_update
#   config_keep_open
#   config_run_script
# Globals:
#   SMALLTALK_CI_IMAGE
#   SMALLTALK_CI_VM
# Returns:
#   Status code of build
################################################################################
squeak::load_project_and_run_tests() {
  local vm_args
  local cog_vm_flags=()

  print_info "Load project into image and run tests..."

  vm_args=(
      ${config_directory} \
      ${config_baseline} \
      ${config_baseline_group} \
      ${config_exclude_categories} \
      ${config_exclude_classes} \
      ${config_force_update} \
      ${config_keep_open}
  )


  if is_travis_build && [[ "${TRAVIS_OS_NAME}" = "linux" ]]; then
    cog_vm_flags=(-nosound -nodisplay)
  fi

  "${SMALLTALK_CI_VM}" "${cog_vm_flags[@]}" "${SMALLTALK_CI_IMAGE}" \
      "${config_run_script}" "${vm_args[@]}"
  return $?
}

################################################################################
# Main entry point for Squeak builds.
# Returns:
#   Status code of build
################################################################################
run_build() {
  squeak::check_options
  squeak::prepare_image "${config_smalltalk}"
  squeak::prepare_vm

  squeak::load_project_and_run_tests
  return $?
}
