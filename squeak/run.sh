#!/bin/bash

set -e

# ==============================================================================
# Set paths and files
# ==============================================================================
readonly VM_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts/filetreeci/vms"
readonly IMAGE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts/filetreeci/images"

# Optional environment variables
[[ -z "${baseline_group}" ]] && baseline_group="TravisCI"
[[ -z "${exclude_categories}" ]] && exclude_categories="nil"
[[ -z "${exclude_classes}" ]] && exclude_classes="nil"
[[ -z "${force_update}" ]] && force_update="false"
[[ -z "${keep_open}" ]] && keep_open="false"
if [[ -z "${run_script}" ]]; then
  run_script="${SMALLTALK_CI_HOME}/squeak/run.st"
else
  run_script="${project_home}/${run_script}"
fi
# ==============================================================================

# ==============================================================================
# Check and specify Squeak image
# ==============================================================================
case "${SMALLTALK}" in
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
    print_error "Unsupported Squeak version '${SMALLTALK}'"
    exit 1
    ;;
esac
# ==============================================================================

# ==============================================================================
# Identify OS and select virtual machine
# ==============================================================================
case "$(uname -s)" in
  "Linux")
    print_info "Linux detected..."
    if [[ "${spur_image}" = true ]]; then
      readonly cog_vm_file_base="cog_linux_spur"
      readonly cog_vm="${SMALLTALK_CI_VMS}/cogspurlinux/bin/squeak"
    else
      readonly cog_vm_file_base="cog_linux"
      readonly cog_vm="${SMALLTALK_CI_VMS}/coglinux/bin/squeak"
    fi
    cog_vm_file="${cog_vm_file_base}.tar.gz"
    if [[ "${TRAVIS}" = "true" ]]; then
      cog_vm_file="${cog_vm_file_base}.min.tar.gz"
      readonly cog_vm_params=(-nosound -nodisplay)
    fi
    readonly cog_vm_file
    ;;
  "Darwin")
    print_info "OS X detected..."
    if [[ "${spur_image}" = true ]]; then
      readonly cog_vm_file_base="cog_osx_spur"
      readonly cog_vm="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
    else
      readonly cog_vm_file_base="cog_osx"
      readonly cog_vm="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
    fi
    readonly cog_vm_file="${cog_vm_file_base}.tar.gz"
    ;;
  *)
    print_error "Unsupported platform '$(uname -s)'"
    exit 1
    ;;
esac
# ==============================================================================

# ==============================================================================
# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "${SMALLTALK_CI_CACHE}/${cog_vm_file}" ]]; then
  print_timed "Downloading virtual machine..."
  download_file "${VM_DOWNLOAD}/${cog_vm_file}" > "${SMALLTALK_CI_CACHE}/${cog_vm_file}"
  print_timed_result "Time to download virtual machine"
fi
if [[ ! -f "$cog_vm" ]]; then
  print_info "Extracting virtual machine..."
  tar xzf "${SMALLTALK_CI_CACHE}/${cog_vm_file}" -C "${SMALLTALK_CI_VMS}"
fi
if [[ ! -f "${SMALLTALK_CI_CACHE}/${image_tar}" ]]; then
  print_timed "Downloading ${SMALLTALK} testing image..."
  download_file "${IMAGE_DOWNLOAD}/${image_tar}" > "${SMALLTALK_CI_CACHE}/${image_tar}"
  print_timed_result "Time to download ${SMALLTALK} testing image"
fi
# ==============================================================================

# ==============================================================================
# Extract image and run on virtual machine
# ==============================================================================
print_info "Extracting image..."
tar xzf "${SMALLTALK_CI_CACHE}/${image_tar}" -C "${SMALLTALK_CI_BUILD}"

print_info "Load project into image and run tests..."
readonly vm_args=(${packages} ${baseline} ${baseline_group} ${exclude_categories} ${exclude_classes} ${force_update} ${keep_open})
"${cog_vm}" "${cog_vm_params[@]}" "${SMALLTALK_CI_IMAGE}" "${run_script}" "${vm_args[@]}" || exit_status=$?
# ==============================================================================
