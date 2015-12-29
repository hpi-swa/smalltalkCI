#!/bin/bash

set -e

readonly BASE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts"
readonly IMAGE_DOWNLOAD="${BASE_DOWNLOAD}/filetreeci/images"
readonly VM_DOWNLOAD="http://mirandabanda.org/files/Cog/VM/VM.r3427"

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
################################################################################
squeak::select_vm() {
  local os_name="$(uname -s)"

  case "${os_name}" in
    "Linux")
      print_info "Linux detected..."
      if is_spur_image "${SMALLTALK_CI_IMAGE}"; then
        readonly cog_vm_file="cogspurlinux-15.33.3427.tgz"
        readonly cog_vm="${SMALLTALK_CI_VMS}/cogspurlinux/bin/squeak"
      else
        readonly cog_vm_file="coglinux-15.33.3427.tgz"
        readonly cog_vm="${SMALLTALK_CI_VMS}/coglinux/bin/squeak"
      fi
      if is_travis_build; then
        cog_vm_params=(-nosound -nodisplay)
      fi
      ;;
    "Darwin")
      print_info "OS X detected..."
      if is_spur_image "${SMALLTALK_CI_IMAGE}"; then
        readonly cog_vm_file="CogSpur.app-15.33.3427.tgz"
        readonly cog_vm="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
      else
        readonly cog_vm_file="Cog.app-15.33.3427.tgz"
        readonly cog_vm="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
      fi
      ;;
    *)
      print_error "Unsupported platform '${os_name}'."
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

  print_info "Cog VM Information:"
  "${cog_vm}" -version
}

################################################################################
# Select Squeak image. Exit with '1' if smalltalk_name is unsupported.
# Arguments:
#   Smalltalk image name
# Returns:
#   Image filename string
################################################################################
squeak::select_image() {
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
# Arguments:
#   smalltalk_name
################################################################################
squeak::prepare_image() {
  local smalltalk_name=$1
  local image_file=$(squeak::select_image "${smalltalk_name}")
  local download_url="${IMAGE_DOWNLOAD}/${image_file}"
  local target="${SMALLTALK_CI_CACHE}/${image_file}"

  if ! is_file "${target}"; then
    print_timed "Downloading ${smalltalk_name} testing image..."
    download_file "${download_url}" > "${target}"
    print_timed_result "Time to download ${smalltalk_name} testing image"
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
  local cog_vm
  local cog_vm_file
  local cog_vm_params=()

  squeak::check_options
  squeak::prepare_image "${smalltalk}"
  squeak::select_vm
  squeak::prepare_vm "${cog_vm_file}"

  squeak::load_project_and_run_tests
  return $?
}
