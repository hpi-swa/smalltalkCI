################################################################################
# This file provides Squeak support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

readonly BASE_DOWNLOAD="https://dl.bintray.com/hpi-swa-lab/smalltalkCI"
readonly VM_DOWNLOAD="${BASE_DOWNLOAD}/vms"

################################################################################
# Prepare Squeak image and vm for build.
# Argument:
#   Smalltalk image name
################################################################################
squeak::prepare_build() {
  local smalltalk_name=$1
  local download_name

  case "${smalltalk_name}" in
    "Squeak-trunk"|"Squeak-Trunk"|"SqueakTrunk"|"Squeak-latest")
      squeak::prepare_trunk_build
      return
      ;;
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
  squeak::prepare_vm
}

squeak::prepare_trunk_build() {
  local target="${SMALLTALK_CI_BUILD}/trunk.zip"
  local status=0

  travis_fold start download_image "Downloading ${config_smalltalk} image..."
    timer_start

    download_file "${BASE_DOWNLOAD}/Squeak-trunk.tar.gz" "${target}"
    tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_BUILD}/TravisCI.image"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_BUILD}/TravisCI.changes"

    timer_finish
  travis_fold end download_image

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Unable to download image at '${SMALLTALK_CI_IMAGE}'."
  fi

  squeak::prepare_vm

  travis_fold start prepare_image "Preparing ${config_smalltalk} image for CI..."
    timer_start

    cp "${SMALLTALK_CI_HOME}/squeak/prepare.st" \
       "${SMALLTALK_CI_BUILD}/prepare.st"
    squeak::run_script "prepare.st" || status=$?

    timer_finish
  travis_fold end prepare_image

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to prepare image for CI." "${status}"
  fi
}

################################################################################
# Download image and extract it.
# Globals:
#   BASE_DOWNLOAD
#   SMALLTALK_CI_CACHE
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_IMAGE
# Argument:
#   download_name
################################################################################
squeak::download_prepared_image() {
  local download_name=$1
  local download_url="${BASE_DOWNLOAD}/${download_name}"
  local target="${SMALLTALK_CI_CACHE}/${download_name}"

  if ! is_file "${target}"; then
    travis_fold start download_image "Downloading '${download_name}' testing image..."
      timer_start
      download_file "${download_url}" "${target}"
      timer_finish
    travis_fold end download_image
  fi

  print_info "Extracting image..."
  tar xzf "${target}" -C "${SMALLTALK_CI_BUILD}"

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
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
  squeakssl_target="${SMALLTALK_CI_CACHE}/squeakssl.zip"
  squeakssl_bin="${SMALLTALK_CI_CACHE}/linux32/SqueakSSL"

  if ! is_file "${target}"; then
    travis_fold start download_vm "Downloading virtual machine..."
      timer_start
      download_file "${download_url}" "${target}"
      timer_finish
    travis_fold end download_vm
  fi

  if ! is_file "${vm_path}"; then
    print_info "Extracting virtual machine..."
    tar xzf "${target}" -C "${SMALLTALK_CI_VMS}"
    if ! is_file "${vm_path}"; then
      print_error_and_exit "Unable to set vm up at '${vm_path}'."
    fi
    chmod +x "${vm_path}"
  fi

  echo "${vm_path} \"\$@\"" > "${SMALLTALK_CI_VM}"
  chmod +x "${SMALLTALK_CI_VM}"

  travis_fold start display_vm_version "Cog VM Information"
    "${SMALLTALK_CI_VM}" -version
  travis_fold end display_vm_version
}

################################################################################
# Return vm flags as string.
################################################################################
squeak::determine_vm_flags() {
  local vm_flags=""
  if is_travis_build || [[ "${config_headless}" = "true" ]]; then
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

  case "$(uname -s)" in
    "Linux"|"Darwin")
      # VMs for Linux and macOS expect full path to script
      script="${SMALLTALK_CI_BUILD}/${script}"
      ;;
  esac

  travis_wait "${SMALLTALK_CI_VM}" ${vm_flags} \
    "$(resolve_path "${SMALLTALK_CI_IMAGE}")" "${script}" || return $?

  return 0
}

################################################################################
# Load project and save image.
# Locals:
#   config_headless
#   config_ston
# Globals:
#   SMALLTALK_CI_IMAGE
#   SMALLTALK_CI_VM
################################################################################
squeak::load_project() {
  local status=0

  cat >"${SMALLTALK_CI_BUILD}/load.st" <<EOL
  [ Metacello new
    baseline: 'SmalltalkCI';
    repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
    onConflict: [:ex | ex pass];
    load ] on: Warning do: [:w | w resume ].
  SmalltalkCI load: '$(resolve_path "${config_ston}")'.
  SmalltalkCI isHeadless ifTrue: [ SmalltalkCI saveAndQuitImage ]
EOL

  squeak::run_script "load.st" || status=$?

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to load project." "${status}"
  fi
}

################################################################################
# Test project.
# Locals:
#   config_headless
#   config_ston
# Globals:
#   SMALLTALK_CI_IMAGE
#   SMALLTALK_CI_VM
################################################################################
squeak::test_project() {
  local status=0
  local build_name=""

  cat >"${SMALLTALK_CI_BUILD}/test.st" <<EOL
  SmalltalkCI test: '$(resolve_path "${config_ston}")'
EOL

  squeak::run_script "test.st" || status=$?
  printf "\n\n"
}

################################################################################
# Main entry point for Squeak builds.
################################################################################
run_build() {
  squeak::prepare_build "${config_smalltalk}"
  squeak::load_project
  squeak::test_project
}
