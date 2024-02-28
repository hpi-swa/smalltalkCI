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
    "Pharo64-alpha"|"Pharo-alpha")
      echo "get.pharo.org/64/alpha"
      ;;
    "Pharo64-stable"|"Pharo-stable")
      echo "get.pharo.org/64/stable"
      ;;
    "Pharo64-12")
      echo "get.pharo.org/64/120"
      ;;
    "Pharo64-11")
      echo "get.pharo.org/64/110"
      ;;
    "Pharo64-10")
      echo "get.pharo.org/64/100"
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
    "Pharo32-alpha")
      echo "get.pharo.org/alpha"
      ;;
    "Pharo32-stable")
      echo "get.pharo.org/stable"
      ;;
    "Pharo32-12")
        echo "get.pharo.org/32/120"
        ;;
    "Pharo32-11")
        echo "get.pharo.org/32/110"
        ;;
    "Pharo32-10")
        echo "get.pharo.org/32/100"
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
      echo "https://github.com/moosetechnology/Moose/releases/download/continuous/Moose11-development-Pharo64-11.zip"
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
      echo "https://github.com/moosetechnology/Moose/releases/download/v8.x.x/Moose8-old-stable-Pharo64-8.0.zip"
      ;;
    "Moose64-9"*)
      echo "https://github.com/moosetechnology/Moose/releases/download/v9.x.x/Moose9-stable-Pharo64-9.0.zip"
      ;;
    "Moose64-10"*)
      echo "https://github.com/moosetechnology/Moose/releases/download/v10.x.x/Moose10-stable-Pharo64-10.zip"
      ;;
    "Moose64-11"*)
      echo "https://github.com/moosetechnology/Moose/releases/download/continuous/Moose11-development-Pharo64-11.zip"
      ;;
    *)
      print_error_and_exit "Unsupported Moose version '${smalltalk_name}'."
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
  local stable_version=11
  local alpha_version=12

  case "${smalltalk_name}" in
    # NOTE: vmLatestXX should be updated every time new Pharo is released
    "Pharo64-alpha"|"Pharo-alpha")
      echo "get.pharo.org/64/vmLatest${alpha_version}0"
      ;;
    "Pharo64-stable"|"Pharo-stable")
      echo "get.pharo.org/64/vm${stable_version}0"
      ;;
    "Pharo64-12")
      echo "get.pharo.org/64/vm120"
      ;;
    "Pharo64-11"|"Moose64-11"|"Moose64-trunk")
      echo "get.pharo.org/64/vm110"
      ;;
    "Pharo64-10"|"Moose64-10")
      echo "get.pharo.org/64/vm100"
      ;;
    "Pharo64-9.0"|"Moose64-9.0")
      echo "get.pharo.org/vm90"
      ;;
    "Pharo64-8.0"|"Moose64-8.0")
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
    "Pharo32-alpha")
      echo "get.pharo.org/vmLatest${alpha_version}0"
      ;;
    "Pharo32-stable")
      echo "get.pharo.org/vm${stable_version}0"
      ;;
    "Pharo32-12")
      echo "get.pharo.org/vm120"
      ;;
    "Pharo32-11")
      echo "get.pharo.org/vm110"
      ;;
    "Pharo32-10")
      echo "get.pharo.org/vm100"
      ;;
    "Pharo32-9.0")
      echo "get.pharo.org/vm90"
      ;;
    "Pharo32-8.0"|"Moose32-8.0"|"Moose32-trunk")
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
      retry 3 "bash ${pharo_zeroconf}"
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

  if "${config_overwrite_cache}" && is_dir "${target}"; then
    print_info "Removing cached image resources for ${smalltalk_name} (update forced)"
    rm -r "${target}"
  fi
  if ! is_dir "${target}"; then
    mkdir "${target}"
  fi
  if ! is_file "${target}"/*.image; then
    pushd "${target}" > /dev/null
    fold_start download_image "Downloading ${smalltalk_name} image..."
      download_file "${pharo_image_url}" "${pharo_zeroconf}"
      retry 3 "bash ${pharo_zeroconf}"
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

  run_script "${resolved_vm}" "${resolved_image}" --no-default-preferences eval ${vm_flags} "${script}"
}

################################################################################
# Load just smalltalkCI project into Pharo image.
# ADDED by SORABITO Inc.
################################################################################
pharo::load_smalltalk_ci_project() {
  pharo::run_script "
    | smalltalkCI |
    $(conditional_debug_halt)
    [ | metacello |
        metacello := Metacello new
            baseline: 'SmalltalkCI';
            repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
            onUpgrade: [ :ex | ex useIncoming ].
        (Metacello canUnderstand: #onConflictUseIncoming)
            ifTrue: [ metacello onConflictUseIncoming ]
            ifFalse: [ metacello onConflict: [ :ex | ex useIncoming ] ].
        metacello load ]
            on: Warning
            do: [ :w | w resume ].
    smalltalkCI := Smalltalk at: #SmalltalkCI.
    smalltalkCI isHeadless ifTrue: [ smalltalkCI saveAndQuitImage ]
  "
}

################################################################################
# Run before scripts.
# ADDED by SORABITO Inc.
################################################################################
pharo::run_before_scripts() {
    print_info "Running before build scripts..."
    if [ -n "${SMALLTALK_CI_BEFORE_BUILD_SCRIPTS_FOLDER+set}" ]; then
      for script_file in $( ls "${SMALLTALK_CI_BEFORE_BUILD_SCRIPTS_FOLDER}" ); do
        echo "Running --- ${SMALLTALK_CI_BEFORE_BUILD_SCRIPTS_FOLDER}/${script_file}"
        pharo::run_script "$(cat ${SMALLTALK_CI_BEFORE_BUILD_SCRIPTS_FOLDER}/${script_file})"
      done
    fi
}

################################################################################
# Run after scripts.
# ADDED by SORABITO Inc.
################################################################################
pharo::run_after_scripts() {
    print_info "Running after build scripts..."
    if [ -n "${SMALLTALK_CI_AFTER_BUILD_SCRIPTS_FOLDER+set}" ]; then
      for script_file in $( ls "${SMALLTALK_CI_AFTER_BUILD_SCRIPTS_FOLDER}" ); do
        echo "Running --- ${SMALLTALK_CI_AFTER_BUILD_SCRIPTS_FOLDER}/${script_file}"
        pharo::run_script "$(cat ${SMALLTALK_CI_AFTER_BUILD_SCRIPTS_FOLDER}/${script_file})"
      done
    fi
}

################################################################################
# Load project into Pharo image.
# UPDATED by SORABITO Inc.
################################################################################
pharo::load_project() {
  pharo::run_script "
    | smalltalkCI |
    smalltalkCI := (Smalltalk at: #SmalltalkCI).
    smalltalkCI load: '$(resolve_path "${config_ston}")'.
    (smalltalkCI isHeadless or: [ smalltalkCI promptToProceed ])
      ifTrue: [ smalltalkCI saveAndQuitImage ]
  "
}

################################################################################
# Run tests for project.
################################################################################
pharo::test_project() {
  pharo::run_script "
    | smalltalkCI |
    $(conditional_debug_halt)
    smalltalkCI := Smalltalk
        at: #SmalltalkCI
        ifAbsent: [
            [ | metacello |
                metacello := Metacello new
                    baseline: 'SmalltalkCI';
                    repository: 'filetree://$(resolve_path "${SMALLTALK_CI_HOME}/repository")';
                    onUpgrade: [ :ex | ex useIncoming ].
                (Metacello canUnderstand: #onConflictUseIncoming)
                    ifTrue: [ metacello onConflictUseIncoming ]
                    ifFalse: [ metacello onConflict: [ :ex | ex useIncoming ] ].
                metacello load ]
                    on: Warning
                    do: [ :w | w resume ].
            Smalltalk at: #SmalltalkCI ].
    smalltalkCI test: '$(resolve_path "${config_ston}")'
  "
}

################################################################################
# configure smalltalk repository
# ADDED by SORABITO Inc.
################################################################################
configure_smalltalk_repository() {
    smalltalk_repository="${SMALLTALK_REPOSITORY:=pharo-repository}"

    ln -s "${TRAVIS_BUILD_DIR}/${smalltalk_repository}" "${SMALLTALK_CI_BUILD}/${smalltalk_repository}"

    ln -s "${TRAVIS_BUILD_DIR}/patch" "${SMALLTALK_CI_BUILD}/patch"
}

################################################################################
# Main entry point for Pharo builds.
# UPDATED by SORABITO Inc.
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
    configure_smalltalk_repository
    pharo::load_smalltalk_ci_project
    pharo::run_before_scripts
    pharo::load_project
    pharo::run_after_scripts
    check_and_consume_build_status_file
  fi
  pharo::test_project
}
