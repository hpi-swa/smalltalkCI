################################################################################
# This file provides GToolkit support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

gtoolkit::latest_release_version() {

  # Get release JSON from GH API (via https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/)
  local url=https://api.github.com/repos/feenkcom/gtoolkit/releases/latest
  local json=$(curl -sL $url)

  # Find the tag name line in the JSON
  local versionLine=$(echo "$json" | grep tag_name)

  # Scrape the value (adapted from https://stackoverflow.com/a/19394523)
  local version=$(echo "$versionLine" | awk -F ': ' '/tag_name/ {gsub("\",?","");print $2}')

  echo "$version"
}

gtoolkit::architecture() {
  local gt_architecture

  case "$(hardware_platform)" in
    "arm64")
      gt_architecture="aarch64"
      ;;
    "x86_64")
      gt_architecture="x86_64"
      ;;
  esac

  echo "$gt_architecture"
}

gtoolkit::archive_basename() {
  local gt_architecture=$(gtoolkit::architecture)
  local gt_platform
  local gt_release=$(gtoolkit::latest_release_version)

  if is_linux_build; then
    gt_platform="Linux"
  elif is_windows_build; then
    if [[ "$gt_architecture" == "aarch64" ]]; then
      print_error_and_exit "unsupported build platform '$(uname -s)'."
    fi
    gt_platform="Windows"
  elif is_mac_build; then
    gt_platform="MacOS"
  else
    print_error_and_exit "unsupported build platform '$(uname -s)'."
  fi

  echo "GlamorousToolkit-${gt_platform}-${gt_architecture}-${gt_release}"
}

gtoolkit::archive_url() {
  local gt_release=$(gtoolkit::latest_release_version)
  local url_base="https://github.com/feenkcom/gtoolkit/releases/download"

  echo "${url_base}/${gt_release}/$(gtoolkit::archive_basename).zip"
}

gtoolkit::vm_path() {
  local result

  if is_linux_build; then
    result="bin/GlamorousToolkit-cli"
  elif is_windows_build; then
    result="bin/GlamorousToolkit-cli.exe"
  elif is_mac_build; then
    result="GlamorousToolkit.app/Contents/MacOS/GlamorousToolkit-cli"
  else
    print_error_and_exit "unsupported build platform '$(uname -s)'."
  fi

  echo "${result}"
}

################################################################################
# Download and move vm if necessary.
# Globals:
#   SMALLTALK_CI_VM
################################################################################

gtoolkit::prepare_vm() {
  local vm_path="$(gtoolkit::vm_path)"

  # Skip in case vm is already set up
  if is_file "${SMALLTALK_CI_VM}"; then
    return 0
  fi

  export SMALLTALK_CI_VM="${SMALLTALK_CI_BUILD}/${vm_path}"

  chmod +x "${SMALLTALK_CI_VM}"

  if ! is_file "${SMALLTALK_CI_VM}"; then
    print_error_and_exit "Unable to set vm up at '${SMALLTALK_CI_VM}'."
  fi
}

################################################################################
# Download GT (image and VM) if necessary and copy it to build folder.
# Globals:
#   SMALLTALK_CI_BUILD
#   SMALLTALK_CI_CACHE
# Arguments:
#   smalltalk_name
################################################################################

gtoolkit::prepare_gt() {
  local smalltalk_name=$1 #Ignore currently because we are only supporting `release`
  local gtoolkit_image_url="$(gtoolkit::archive_url)"
  local download_name="$(gtoolkit::archive_basename)"
  local target="${SMALLTALK_CI_CACHE}/${download_name}.zip"

  if ! is_file "${target}"; then
    fold_start download_image "Downloading ${smalltalk_name} image..."
      download_file "${gtoolkit_image_url}" "${target}"
    fold_end download_image
  fi

  print_info "Extracting GT..."
  extract_file "${target}" "${SMALLTALK_CI_BUILD}"
  echo "${download_name}" > "${SMALLTALK_CI_BUILD}"/version

  print_info "Preparing GToolkit image..."
  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    mv "${SMALLTALK_CI_BUILD}"/*.image "${SMALLTALK_CI_IMAGE}"
    mv "${SMALLTALK_CI_BUILD}"/*.changes "${SMALLTALK_CI_CHANGES}"
  fi

  if ! vm_is_user_provided; then
    gtoolkit::prepare_vm
  fi

  if ! is_file "${SMALLTALK_CI_IMAGE}"; then
    print_error_and_exit "Failed to prepare image at '${SMALLTALK_CI_IMAGE}'."
  fi
}


################################################################################
# Run a Smalltalk script.
# NB. copy/pasted from Pharo
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
# NB. copy/pasted from Pharo
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
# NB. copy/pasted from Pharo
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
    gtoolkit::prepare_gt "${config_smalltalk}"
  fi

  if ston_includes_loading; then
    gtoolkit::load_project
    check_and_consume_build_status_file
  fi
  gtoolkit::test_project
}
