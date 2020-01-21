################################################################################
# This file provides Pharo support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

################################################################################
# Select Pharo image download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   Pharo image download url
################################################################################

pharo::get_image_url() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    "Pharo64-alpha")
      echo "get.pharo.org/64/alpha"
      ;;
    "Pharo64-stable")
      echo "get.pharo.org/64/stable"
      ;;
    "Pharo64-9.0")
      echo "get.pharo.org/64/90"
      ;;
    "Pharo64-8.0")
      echo "get.pharo.org/64/80"
      ;;
    "Pharo64-7.0")
      echo "get.pharo.org/64/70"
      ;;
    "Pharo64-6.1")
      echo "get.pharo.org/64/61"
      ;;
    "Pharo64-6.0")
      echo "get.pharo.org/64/60"
      ;;
    "Pharo32-alpha"|"Pharo-alpha")
      echo "get.pharo.org/alpha"
      ;;
    "Pharo32-stable"|"Pharo-stable")
      echo "get.pharo.org/stable"
      ;;
    "Pharo32-9.0")
        echo "get.pharo.org/32/90"
        ;;
    "Pharo32-8.0")
        echo "get.pharo.org/80"
        ;;
    "Pharo32-7.0"|"Pharo-7.0")
      echo "get.pharo.org/70"
      ;;
    "Pharo32-6.0"|"Pharo-6.0")
      echo "get.pharo.org/60"
      ;;
    "Pharo32-6.1"|"Pharo-6.1")
      echo "get.pharo.org/61"
      ;;
    "Pharo32-5.0"|"Pharo-5.0")
      echo "get.pharo.org/50"
      ;;
    "Pharo32-4.0"|"Pharo-4.0")
      echo "get.pharo.org/40"
      ;;
    "Pharo32-3.0"|"Pharo-3.0")
      echo "get.pharo.org/30"
      ;;
    *)
      print_error_and_exit "Unsupported Pharo version '${smalltalk_name}'."
      ;;
  esac
}

################################################################################
# Select Moose image download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   Moose image download url
################################################################################
moose::get_image_url() {
  local smalltalk_name=$1
  local moose_name

  case "${smalltalk_name}" in
    "Moose64-trunk"|"Moose-trunk")
     echo "https://ci.inria.fr/moose/view/Moose%208.0/job/Moose-8/ARCHITECTURE=64,PHARO=80,VERSION=development,VM=vm/lastSuccessfulBuild/artifact/Moose.zip"
      ;;
    "Moose32-trunk")
      moose_name="moose-7.0"
        echo "https://ci.inria.fr/moose/job/${moose_name}/lastSuccessfulBuild/artifact/${moose_name}.zip"
      ;;
    "Moose64-7"*)
      moose_name="moose-$(echo "${smalltalk_name}" | cut -f2 -d-)-64bit"
        echo "https://ci.inria.fr/moose/job/${moose_name}/lastSuccessfulBuild/artifact/${moose_name}.zip"
      ;;
    "Moose32-6"*|"Moose-6"*|"Moose32-7"*|"Moose-7"*)
      moose_name="moose-$(echo "${smalltalk_name}" | cut -f2 -d-)"
        echo "https://ci.inria.fr/moose/job/${moose_name}/lastSuccessfulBuild/artifact/${moose_name}.zip"
      ;;
     "Moose64-8"*)
      echo "https://ci.inria.fr/moose/view/Moose%208.0/job/Moose-8/ARCHITECTURE=64,PHARO=80,VERSION=development,VM=vm/lastSuccessfulBuild/artifact/Moose.zip"
      ;;
    *)
      print_error_and_exit "Unsupported Pharo version '${smalltalk_name}'."
      ;;
  esac

}

################################################################################
# Select Pharo vm download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   Pharo vm download url
################################################################################
pharo::get_vm_url() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    # NOTE: vmLatestXX should be updated every time new Pharo is released
    "Pharo64-alpha")
      echo "get.pharo.org/64/vmLatest90"
      ;;
    "Pharo64-9.0")
      echo "get.pharo.org/64/vm90"
      ;;
    "Pharo64-stable"|"Pharo64-8.0"|"Moose64-8.0"|"Moose64-trunk")
      echo "get.pharo.org/64/vm80"
      ;;
    "Pharo64-7.0"|"Moose64-7.0")
      echo "get.pharo.org/64/vm70"
      ;;
    "Pharo64-6.1")
      echo "get.pharo.org/64/vm61"
      ;;
    "Pharo64-6.0")
      echo "get.pharo.org/64/vm60"
      ;;
    "Pharo32-alpha"|"Pharo-alpha")
      echo "get.pharo.org/vmLatest90"
      ;;
    "Pharo32-9.0")
      echo "get.pharo.org/vm90"
      ;;
    "Pharo-stable"|"Pharo32-stable"|"Pharo32-8.0"|"Moose32-8.0"|"Moose32-trunk")
      echo "get.pharo.org/vm80"
      ;;
    "Pharo32-7.0"|"Pharo-7.0"|"Moose32-7.0"|"Moose-7.0")
      echo "get.pharo.org/vm70"
      ;;
    "Pharo32-6.1"|"Moose32-6.1"|"Pharo-6.1"|"Moose-6.1")
      echo "get.pharo.org/vm61"
      ;;
    "Pharo32-6.0"|"Pharo-6.0")
      echo "get.pharo.org/vm60"
      ;;
    "Pharo32-5.0"|"Moose32-6.0"|"Pharo-5.0"|"Moose-6.0")
      echo "get.pharo.org/vm50"
      ;;
    "Pharo32-4.0"|"Pharo-4.0")
      echo "get.pharo.org/vm40"
      ;;
    "Pharo32-3.0"|"Pharo-3.0")
      echo "get.pharo.org/vm30"
      ;;
    *)
      print_error_and_exit "Unsupported Pharo version '${smalltalk_name}'."
      ;;
  esac
}

################################################################################
# Download and move vm if necessary.
# Globals:
#   SMALLTALK_CI_VM
# Arguments:
#   smalltalk_name
################################################################################
pharo::prepare_vm() {
  local smalltalk_name=$1
  local pharo_vm_url="$(pharo::get_vm_url "${smalltalk_name}")"
  local pharo_zeroconf="${config_vm_dir}/zeroconfig"

  # Skip in case vm is already set up
  if is_file "${SMALLTALK_CI_VM}"; then
    return 0
  fi

  if ! is_dir "${config_vm_dir}"; then
    is_dir "${config_vm_dir}" || mkdir -p "${config_vm_dir}"
    pushd "${config_vm_dir}" > /dev/null
    fold_start download_vm "Downloading ${smalltalk_name} vm..."
      download_file "${pharo_vm_url}" "${pharo_zeroconf}"
      bash "${pharo_zeroconf}"
    fold_end download_vm
    popd > /dev/null
  fi

  if is_headless; then
    echo "${config_vm_dir}/pharo \"\$@\"" > "${SMALLTALK_CI_VM}"
  else
    echo "${config_vm_dir}/pharo-ui \"\$@\"" > "${SMALLTALK_CI_VM}"
  fi
  chmod +x "${SMALLTALK_CI_VM}"

  if ! is_file "${SMALLTALK_CI_VM}"; then
    print_error_and_exit "Unable to set vm up at '${SMALLTALK_CI_VM}'."
  fi
}

################################################################################
# Download image if necessary and copy it to build folder.
# Globals:
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_CACHE
# Arguments:
#   smalltalk_name
################################################################################
pharo::prepare_image() {
  local smalltalk_name=$1
  local pharo_image_url="$(pharo::get_image_url "${smalltalk_name}")"
  local target="${SMALLTALK_CI_CACHE}/${smalltalk_name}"
  local pharo_zeroconf="${target}/zeroconfig"

  if ! is_file "${target}"; then
    is_dir "${target}" || mkdir "${target}"
    pushd "${target}" > /dev/null
    fold_start download_image "Downloading ${smalltalk_name} image..."
      download_file "${pharo_image_url}" "${pharo_zeroconf}"
      bash "${pharo_zeroconf}"
    fold_end download_image
    popd > /dev/null
  fi

  print_info "Preparing Pharo image..."
  cp "${target}/"*.image "${SMALLTALK_CI_IMAGE}"
  cp "${target}/"*.changes "${SMALLTALK_CI_CHANGES}"
  if ls "${target}/"*.sources 1> /dev/null 2>&1; then
    cp "${target}/"*.sources "${SMALLTALK_CI_BUILD}"
  fi
}

################################################################################
# Download Moose image if necessary and extract it into build folder.
# Globals:
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_CACHE
# Arguments:
#   smalltalk_name
################################################################################
pharo::prepare_moose_image() {
  local smalltalk_name=$1
  local moose_image_url="$(moose::get_image_url "${smalltalk_name}")"
  local target="${SMALLTALK_CI_CACHE}/${smalltalk_name}.zip"

  if ! is_file "${target}"; then
    fold_start download_image "Downloading ${smalltalk_name} image..."
      set +e
      download_file "${moose_image_url}" "${target}"
      if [[ ! $? -eq 0 ]]; then
        rm -f "${target}"
        print_error_and_exit "Download failed."
      fi
      set -e
    fold_end download_image
  fi

  print_info "Extracting and preparing ${smalltalk_name} image..."
  unzip -q "${target}" -d "${SMALLTALK_CI_BUILD}"
  mv "${SMALLTALK_CI_BUILD}/"*.image "${SMALLTALK_CI_IMAGE}"
  mv "${SMALLTALK_CI_BUILD}/"*.changes "${SMALLTALK_CI_CHANGES}"

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
  fi
}

################################################################################
# Run a Smalltalk script.
################################################################################
pharo::run_script() {
  local script=$1
  local vm_flags=""
  local resolved_vm="${config_vm:-${SMALLTALK_CI_VM}}"
  local resolved_image="$(resolve_path "${config_image:-${SMALLTALK_CI_IMAGE}}")"

  if ! is_travis_build && ! is_headless; then
    vm_flags="--no-quit"
  fi

  travis_wait "${resolved_vm}" "${resolved_image}" --no-default-preferences eval ${vm_flags} "${script}"
}

################################################################################
# Load project into Pharo image.
################################################################################
pharo::load_project() {
  pharo::run_script "
    | smalltalkCI |
    $(conditional_debug_halt)
    [ Metacello new
        baseline: 'SmalltalkCI';
        repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
        onConflict: [:ex | ex pass];
        load ] on: Warning do: [:w | w resume ].
    smalltalkCI := (Smalltalk at: #SmalltalkCI).
    smalltalkCI load: '$(resolve_path "${config_ston}")'.
    smalltalkCI isHeadless ifTrue: [ smalltalkCI saveAndQuitImage ]
  "
}

################################################################################
# Run tests for project.
################################################################################
pharo::test_project() {
  pharo::run_script "
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
  "
}

################################################################################
# Main entry point for Pharo builds.
################################################################################
run_build() {
  if ! image_is_user_provided; then
    case "${config_smalltalk}" in
      Pharo*)
        pharo::prepare_image "${config_smalltalk}"
        ;;
      Moose*)
        pharo::prepare_moose_image "${config_smalltalk}"
        ;;
    esac
  fi

  if ! vm_is_user_provided; then
    pharo::prepare_vm "${config_smalltalk}"
  fi
  if ston_includes_loading; then
    pharo::load_project
    check_and_consume_build_status_file
  fi
  pharo::test_project
}
