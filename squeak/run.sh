################################################################################
# This file provides Squeak support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

readonly BASE_DOWNLOAD="${GITHUB_REPO_URL}/releases/download"

################################################################################
# Download Squeak image.
################################################################################
squeak::download_image() {
  local smalltalk_name=$1
  local download_name
  local git_tag

  case "${smalltalk_name}" in
    "Squeak64-6.0")
      download_name="Squeak64-6.0-22104.tar.gz"
      git_tag="v3.0.0"
      ;;
    "Squeak64-5.3")
      download_name="Squeak64-5.3-19438.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak64-5.2")
      download_name="Squeak64-5.2-18236.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak64-5.1")
      download_name="Squeak64-5.1-16555.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak32-6.0")
      download_name="Squeak32-6.0-22104.tar.gz"
      git_tag="v3.0.0"
      ;;
    "Squeak32-5.3")
      download_name="Squeak32-5.3-19438.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak32-5.2"|"Squeak-5.2"|"Squeak5.2")
      download_name="Squeak32-5.2-18236.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak32-5.1"|"Squeak-5.1"|"Squeak5.1")
      download_name="Squeak32-5.1-16555.tar.gz"
      git_tag="v2.9.4"
      ;;
    "Squeak32-5.0"|"Squeak-5.0"|"Squeak5.0")
      download_name="Squeak-5.0.tar.gz"
      git_tag="v2.7.5"
      ;;
    "Squeak32-4.6"|"Squeak-4.6"|"Squeak4.6")
      download_name="Squeak-4.6.tar.gz"
      git_tag="v2.7.5"
      ;;
    "Squeak32-4.5"|"Squeak-4.5"|"Squeak4.5")
      download_name="Squeak-4.5.tar.gz"
      git_tag="v2.7.5"
      ;;
    *)
      print_error_and_exit "Unsupported Squeak version '${smalltalk_name}'."
      ;;
  esac

  squeak::download_prepared_image "${download_name}" "${git_tag}"
}

################################################################################
# Download image and extract it.
################################################################################
squeak::download_prepared_image() {
  local download_name=$1
  local git_tag=$2
  local target="${SMALLTALK_CI_CACHE}/${download_name}"

  if "${config_overwrite_cache}" && is_file "${target}"; then
    print_info "Removing cached image resources for ${smalltalk_name} (update forced)"
    rm "${target}"
  fi
  if ! is_file "${target}"; then
    fold_start download_image "Downloading '${download_name}' testing image..."
      download_file "${BASE_DOWNLOAD}/${git_tag}/${download_name}" "${target}"
    fold_end download_image
  fi

  print_info "Extracting image..."
  extract_file "${target}" "${SMALLTALK_CI_BUILD}"
  # TODO: cleanup soon, some archives still include TravisCI.(image|changes)
  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_IMAGE}"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_CHANGES}"
  fi

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
  fi
}

################################################################################
# Download trunk image and extract it.
################################################################################
squeak::download_trunk_image() {
  local target
  local download_name
  local git_tag="v3.0.5" # 32bit/64bit are kept in sync
  local update_level="22906" # 32bit/64bit are kept in sync

  if is_64bit; then
    download_name="Squeak64-trunk-${update_level}.tar.gz"
  else
    download_name="Squeak32-trunk-${update_level}.tar.gz"
  fi
  target="${SMALLTALK_CI_BUILD}/${download_name}"

  fold_start download_image "Downloading ${config_smalltalk} image..."
    download_file "${BASE_DOWNLOAD}/${git_tag}/${download_name}" "${target}"
    extract_file "${target}" "${SMALLTALK_CI_BUILD}"
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_IMAGE}"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_CHANGES}"
  fold_end download_image

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Unable to download image at '${SMALLTALK_CI_IMAGE}'."
  fi
}

################################################################################
# Ensure Metacello is installed and image is up-to-date.
################################################################################
squeak::prepare_image() {
  local status=0

  fold_start prepare_image "Preparing ${config_smalltalk} image for CI..."
    cp "${SMALLTALK_CI_HOME}/squeak/prepare.st" \
       "${SMALLTALK_CI_BUILD}/prepare.st"
    squeak::run_script "prepare.st" || status=$?
  fold_end prepare_image

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to prepare image for CI." "${status}"
  fi
}

################################################################################
# Get vm filename and path according to build environment. Exit with '1' if
# environment is not supported.
# Arguments:
#   os_name
#   require_spur: '1' for Spur support
# Prints:
#   'vm_filename|vm_path' string
################################################################################
squeak::get_vm_details() {
  local smalltalk_name=$1
  local os_name=$2
  local require_spur=$3
  local git_tag
  local osvm_version
  local vm_arch
  local vm_arch_linux_prefix=""
  local vm_file_ext
  local vm_filename
  local vm_path
  local vm_path_linux_name=""
  local vm_path_linux_suffix="ht"

  if is_trunk_build; then
    git_tag="v2.9.9"
    osvm_version="202206021410"
  else 
    case "${smalltalk_name}" in
      "Squeak32-6.0"|"Squeak64-6.0")
        git_tag="v2.9.9"
        osvm_version="202206021410"
        ;;
      "Squeak64-5.3")
        git_tag="v2.9.1"
        osvm_version="202003021730"
        ;;
      *)
        git_tag="v2.8.4"
        osvm_version="201810190412"
        vm_arch_linux_prefix="_itimer"
        vm_path_linux_suffix=""
        ;;
    esac
  fi

  case "${os_name}" in
    "Linux")
      if is_64bit; then
        vm_arch="linux64x64${vm_arch_linux_prefix}"
      else
        vm_arch="linux32x86${vm_arch_linux_prefix}"
      fi
      vm_file_ext="tar.gz"
      if [[ "${require_spur}" -eq 1 ]]; then
        if is_64bit; then
          vm_path_linux_name="sqcogspur64linux"
        else
          if [[ "${osvm_version}" -ge "202206021410" ]]; then
            vm_path_linux_name="sqcogspur32linux"
          else
            vm_path_linux_name="sqcogspurlinux"
          fi
        fi
      else
        vm_path_linux_name="sqcoglinux"
      fi
      vm_path="${config_vm_dir}/${vm_path_linux_name}${vm_path_linux_suffix}/squeak"
      ;;
    "Darwin")
      if is_64bit; then
        vm_arch="macos64x64"
      else
        vm_arch="macos32x86"
      fi
      vm_file_ext="dmg"
      vm_path="${config_vm_dir}/Squeak.app/Contents/MacOS/Squeak"
      ;;
    "CYGWIN_NT-"*|"MINGW64_NT-"*|"MSYS_NT-"*)
      if is_64bit; then
        vm_arch="win64x64"
      else
        vm_arch="win32x86"
      fi
      vm_file_ext="zip"
      vm_path="${config_vm_dir}/SqueakConsole.exe"
      ;;
    *)
      print_error_and_exit "Unsupported platform '${os_name}'."
      ;;
  esac

  if [[ "${require_spur}" -eq 1 ]]; then
    vm_filename="squeak.cog.spur_${vm_arch}_${osvm_version}.${vm_file_ext}"
  else
    vm_filename="squeak.cog.v3_${vm_arch}_${osvm_version}.${vm_file_ext}"
  fi

  return_vars "${vm_filename}" "${vm_path}" "${git_tag}"
}

################################################################################
# Download and extract vm if necessary.
################################################################################
squeak::prepare_vm() {
  local require_spur=0
  local vm_details
  local vm_filename
  local vm_path
  local download_url
  local target

  is_spur_image "${config_image:-${SMALLTALK_CI_IMAGE}}" && require_spur=1
  vm_details=$(squeak::get_vm_details \
    "${config_smalltalk}" "$(uname -s)" "${require_spur}")
  set_vars vm_filename vm_path git_tag "${vm_details}"
  download_url="${BASE_DOWNLOAD}/${git_tag}/${vm_filename}"
  target="${SMALLTALK_CI_CACHE}/${vm_filename}"

  if ! is_file "${target}"; then
    fold_start download_vm "Downloading virtual machine..."
      download_file "${download_url}" "${target}"
    fold_end download_vm
  fi

  if ! is_file "${vm_path}"; then
    is_dir "${config_vm_dir}" || mkdir -p "${config_vm_dir}"
    print_info "Extracting virtual machine..."
    extract_file "${target}" "${config_vm_dir}"
    if ! is_file "${vm_path}"; then
      print_error_and_exit "Unable to set vm up at '${vm_path}'."
    fi
    chmod +x "${vm_path}"
    if is_cygwin_build || is_mingw64_build; then
      chmod +x "$(dirname ${vm_path})/"*.dll
    fi
  fi

  echo "${vm_path} \"\$@\"" > "${SMALLTALK_CI_VM}"
  chmod +x "${SMALLTALK_CI_VM}"

  fold_start display_vm_version "Cog VM Information"
    "${SMALLTALK_CI_VM}" -version
  fold_end display_vm_version
}

################################################################################
# Return vm flags as string.
################################################################################
squeak::determine_vm_flags() {
  local vm_flags=""
  if is_travis_build || is_headless; then
    case "$(uname -s)" in
      "Linux")
        vm_flags="-nosound -vm-display-null"
        ;;
      "Darwin"|"CYGWIN_NT-"*|"MINGW64_NT-"*)
        vm_flags="-headless"
        ;;
    esac
  fi
  echo "${vm_flags}"
}

################################################################################
# Run a .st script located in $SMALLTALK_CI_BUILD
################################################################################
squeak::run_script() {
  local script=$1
  local vm_flags="$(squeak::determine_vm_flags)"
  local resolved_vm="${config_vm:-${SMALLTALK_CI_VM}}"
  local resolved_image="$(resolve_path "${config_image:-${SMALLTALK_CI_IMAGE}}")"

  case "$(uname -s)" in
    "Linux"|"Darwin")
      # VMs for Linux and macOS expect full path to script
      script="${SMALLTALK_CI_BUILD}/${script}"
      ;;
  esac

  run_script "${resolved_vm}" ${vm_flags} "${resolved_image}" "${script}"
}

################################################################################
# Load smalltalkCI and the project and save image.
################################################################################
squeak::load_project() {
  cat >"${SMALLTALK_CI_BUILD}/load.st" <<EOL
  | smalltalkCI |
  $(conditional_debug_halt)
  [ Metacello new
    baseline: 'SmalltalkCI';
    repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
    onConflict: [:ex | ex pass];
    load ] on: Warning do: [:w | w resume ].
  smalltalkCI := Smalltalk at: #SmalltalkCI.
  smalltalkCI load: '$(resolve_path "${config_ston}")'.
  (smalltalkCI isHeadless or: [smalltalkCI promptToProceed])
      ifTrue: [ smalltalkCI saveAndQuitImage ]
EOL

  squeak::run_script "load.st"
}

################################################################################
# Ensure smalltalkCI is loaded and test project.
################################################################################
squeak::test_project() {
  cat >"${SMALLTALK_CI_BUILD}/test.st" <<EOL
  | smalltalkCI |
  $(conditional_debug_halt)
  smalltalkCI := Smalltalk at: #SmalltalkCI ifAbsent: [
    [ Metacello new
      baseline: 'SmalltalkCI';
      repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
      onConflict: [:ex | ex pass];
      load ] on: Warning do: [:w | w resume ].
      Smalltalk at: #SmalltalkCI
  ].
  smalltalkCI test: '$(resolve_path "${config_ston}")'
EOL

  squeak::run_script "test.st"

  printf "\n\n"
}

################################################################################
# Main entry point for Squeak builds.
################################################################################
run_build() {
  if ! image_is_user_provided; then
    if is_trunk_build; then
      squeak::download_trunk_image
    else
      squeak::download_image "${config_smalltalk}"
    fi
  fi
  if ! vm_is_user_provided; then
    squeak::prepare_vm
  fi
  if is_trunk_build || image_is_user_provided; then
    squeak::prepare_image
  fi
  if ston_includes_loading; then
    squeak::load_project
    check_and_consume_build_status_file
  fi
  squeak::test_project
}
