################################################################################
# This file provides Squeak support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

readonly BASE_DOWNLOAD="https://dl.bintray.com/hpi-swa-lab/smalltalkCI"
readonly VM_DOWNLOAD="${BASE_DOWNLOAD}/vms"

################################################################################
# Download Squeak image.
################################################################################
squeak::download_image() {
  local smalltalk_name=$1
  local download_name

  case "${smalltalk_name}" in
    "Squeak-5.1"|"Squeak5.1")
      download_name="Squeak-5.1.tar.gz"
      ;;
    "Squeak-5.0"|"Squeak5.0")
      download_name="Squeak-5.0.tar.gz"
      ;;
    "Squeak-4.6"|"Squeak4.6")
      download_name="Squeak-4.6.tar.gz"
      ;;
    "Squeak-4.5"|"Squeak4.5")
      download_name="Squeak-4.5.tar.gz"
      ;;
    *)
      print_error_and_exit "Unsupported Squeak version '${smalltalk_name}'."
      ;;
  esac

  squeak::download_prepared_image "${download_name}"
}

################################################################################
# Download image and extract it.
################################################################################
squeak::download_prepared_image() {
  local download_name=$1
  local download_url="${BASE_DOWNLOAD}/${download_name}"
  local target="${SMALLTALK_CI_CACHE}/${download_name}"

  if ! is_file "${target}"; then
    fold_start download_image "Downloading '${download_name}' testing image..."
      download_file "${download_url}" "${target}"
    fold_end download_image
  fi

  print_info "Extracting image..."
  tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
  fi
}

################################################################################
# Download trunk image and extract it.
################################################################################
squeak::download_trunk_image() {
  local target="${SMALLTALK_CI_BUILD}/trunk.zip"

  fold_start download_image "Downloading ${config_smalltalk} image..."
    download_file "${BASE_DOWNLOAD}/Squeak-trunk.tar.gz" "${target}"
    tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_BUILD}/TravisCI.image"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_BUILD}/TravisCI.changes"
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
  local os_name=$1
  local require_spur=$2
  local vm_filename
  local vm_path

  case "${os_name}" in
    "Linux")
      if [[ "${require_spur}" -eq 1 ]]; then
        vm_filename="cogspurlinux-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/cogspurlinux/squeak"
      else
        vm_filename="coglinux-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/coglinux/squeak"
      fi
      ;;
    "Darwin")
      if [[ "${require_spur}" -eq 1 ]]; then
        vm_filename="CogSpur.app-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak"
      else
        vm_filename="Cog.app-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak"
      fi
      ;;
    "CYGWIN_NT-"*)
      if [[ "${require_spur}" -eq 1 ]]; then
        vm_filename="cogspurwin-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/cogspurwin/SqueakConsole.exe"
      else
        vm_filename="cogwin-15.33.3427.tgz"
        vm_path="${SMALLTALK_CI_VMS}/cogwin/SqueakConsole.exe"
      fi
      ;;
    *)
      print_error_and_exit "Unsupported platform '${os_name}'."
      ;;
  esac

  return_vars "${vm_filename}" "${vm_path}"
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
  vm_details=$(squeak::get_vm_details "$(uname -s)" "${require_spur}")
  set_vars vm_filename vm_path "${vm_details}"
  download_url="${VM_DOWNLOAD}/${vm_filename}"
  target="${SMALLTALK_CI_CACHE}/${vm_filename}"

  if ! is_file "${target}"; then
    fold_start download_vm "Downloading virtual machine..."
      download_file "${download_url}" "${target}"
    fold_end download_vm
  fi

  if ! is_file "${vm_path}"; then
    print_info "Extracting virtual machine..."
    tar xzf "${target}" -C "${SMALLTALK_CI_VMS}"
    if ! is_file "${vm_path}"; then
      print_error_and_exit "Unable to set vm up at '${vm_path}'."
    fi
    chmod +x "${vm_path}"
    if is_cygwin_build; then
      chmod +x "$(dirname ${vm_path})/"*.dll "$(dirname ${vm_path})/"*.DLL
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
        vm_flags="-nosound -nodisplay"
        ;;
      "Darwin"|"CYGWIN_NT-"*)
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

  travis_wait "${resolved_vm}" ${vm_flags} "${resolved_image}" "${script}"
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
  smalltalkCI isHeadless ifTrue: [ smalltalkCI saveAndQuitImage ]
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
