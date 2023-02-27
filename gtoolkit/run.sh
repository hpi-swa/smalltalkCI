################################################################################
# This file provides GToolkit support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

################################################################################
# Select GToolkit image download url. Exit if smalltalk_name is unsupported.
# Arguments:
#   smalltalk_name
# Return:
#   GToolkit image download url
################################################################################

gtoolkit::get_gt_url() {
  local smalltalk_name=$1

  case "${smalltalk_name}" in
    "GToolkit-release")
      #echo "https://dl.feenk.com/gt/GlamorousToolkitLinux64-release.zip"
      echo "https://dl.feenk.com/gt/GlamorousToolkitOSXM1-release.zip"
      ;;
    *)
      print_error_and_exit "Unsupported GToolkit version '${smalltalk_name}'."
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
gtoolkit::prepare_vm() {
  local smalltalk_name=$1

  # Skip in case vm is already set up
  if is_file "${SMALLTALK_CI_VM}"; then
    return 0
  fi

  if ! is_dir "${config_vm_dir}"; then
    is_dir "${config_vm_dir}" || mkdir -p "${config_vm_dir}"
    pushd "${config_vm_dir}" > /dev/null
    fold_start download_vm "Downloading ${smalltalk_name} vm..."
      download_file "${gtoolkit_vm_url}" "${gtoolkit_zeroconf}"
      bash "${gtoolkit_zeroconf}"
    fold_end download_vm
    popd > /dev/null
  fi

  if is_headless; then
    echo "${config_vm_dir}/gtoolkit \"\$@\"" > "${SMALLTALK_CI_VM}"
  else
    echo "${config_vm_dir}/gtoolkit-ui \"\$@\"" > "${SMALLTALK_CI_VM}"
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
gtoolkit::download_gt() {
  local smalltalk_name=$1
  local gtoolkit_image_url="$(gtoolkit::get_gt_url "${smalltalk_name}")"
  local target="${SMALLTALK_CI_CACHE}/${smalltalk_name}.zip"
  #local gtoolkit_zeroconf="${target}/zeroconfig"

  if ! is_file "${target}"; then
    #pushd "${target}" > /dev/null
    fold_start download_image "Downloading ${smalltalk_name} image..."
      download_file "${gtoolkit_image_url}" "${target}"
    fold_end download_image
    #popd > /dev/null
  fi

  print_info "Extracting image..."
  extract_file "${target}" "${SMALLTALK_CI_BUILD}"

  print_info "Preparing GToolkit image..."
  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_IMAGE}"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_CHANGES}"
  fi

  #export SMALLTALK_CI_VM="${SMALLTALK_CI_BUILD}/bin/GlamorousToolkit-cli"
  export SMALLTALK_CI_VM="${SMALLTALK_CI_BUILD}/GlamorousToolkit.app/Contents/MacOS/GlamorousToolkit-cli"

  #From Pharo, not in Squeak. Not sure if/how to adapt
  #if ls "${SMALLTALK_CI_BUILD}/"*.sources 1> /dev/null 2>&1; then
  #  mv "${SMALLTALK_CI_BUILD}/"*.sources "${SMALLTALK_CI_BUILD}"
  #fi

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
  fi
}

################################################################################
# Run a Smalltalk script.
################################################################################
gtoolkit::run_script() {
  local script=$1
  local vm_flags=""
  local resolved_vm="${config_vm:-${SMALLTALK_CI_VM}}"
  local resolved_image="$(resolve_path "${config_image:-${SMALLTALK_CI_IMAGE}}")"

  if ! is_travis_build && ! is_headless; then
    vm_flags="--no-quit"
  fi

  run_script "${resolved_vm}" "${resolved_image}" eval ${vm_flags} "${script}"
}

################################################################################
# Load project into GToolkit image.
################################################################################
gtoolkit::load_project() {
  gtoolkit::run_script "
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
    smalltalkCI load: '$(resolve_path "${config_ston}")'.
    (smalltalkCI isHeadless or: [ smalltalkCI promptToProceed ])
      ifTrue: [ smalltalkCI saveAndQuitImage ]
  "
}

################################################################################
# Run tests for project.
################################################################################
gtoolkit::test_project() {
  gtoolkit::run_script "
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
# Main entry point for GToolkit builds.
################################################################################
run_build() {
  if ! image_is_user_provided; then
    case "${config_smalltalk}" in
      GToolkit*)
        gtoolkit::download_gt "${config_smalltalk}"
        ;;
      #Pharo had Moose as a second option here. Maybe we don't need the switch at all?
    esac
  fi

  if ! vm_is_user_provided; then
    gtoolkit::prepare_vm "${config_smalltalk}"
  fi
  if ston_includes_loading; then
    gtoolkit::load_project
    check_and_consume_build_status_file
  fi
  gtoolkit::test_project
}
