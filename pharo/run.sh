#!/bin/bash

set -e

# Determine Pharo download url
# ==============================================================================
case "${SMALLTALK}" in
    "Pharo-alpha")
        readonly PHARO_GET_IMAGE="alpha"
        readonly PHARO_GET_VM="vm50"
        ;;
    "Pharo-stable")
        readonly PHARO_GET_IMAGE="stable"
        readonly PHARO_GET_VM="vm40"
        ;;
    "Pharo-5.0")
        readonly PHARO_GET_IMAGE="50"
        readonly PHARO_GET_VM="vm50"
        ;;
    "Pharo-4.0")
        readonly PHARO_GET_IMAGE="40"
        readonly PHARO_GET_VM="vm40"
        ;;
    "Pharo-3.0")
        readonly PHARO_GET_IMAGE="30"
        readonly PHARO_GET_VM="vm30"
        ;;
    *)
        print_error "Unsupported Pharo version '${SMALLTALK}'"
        exit 1
        ;;
esac
# ==============================================================================
 
# Set paths and files
# ==============================================================================
readonly PHARO_IMAGE="${SMALLTALK}.image"
readonly PHARO_CHANGES="${SMALLTALK}.changes"
if [[ "${keep_open}" = "true" ]]; then
    readonly PHARO_VM="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo-ui"
else
    readonly PHARO_VM="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo"
fi

# Make sure options are set
[[ -z "${baseline_group}" ]] && baseline_group="default"
[[ -z "${packages}" ]] && packages=""
[[ -z "${tests}" ]] && tests="${baseline}.*"
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}" ]]; then
    print_timed "Downloading ${SMALLTALK} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null
    download_file "get.pharo.org/${PHARO_GET_IMAGE}" | bash
    mv Pharo.image "${SMALLTALK}.image"
    mv Pharo.changes "${SMALLTALK}.changes"
    popd > /dev/null
    print_timed_result "Time to download ${SMALLTALK} image"
fi

if [[ ! -d "${SMALLTALK_CI_VMS}/${SMALLTALK}" ]]; then
    print_timed "Downloading ${SMALLTALK} vm..."
    mkdir "${SMALLTALK_CI_VMS}/${SMALLTALK}"
    pushd "${SMALLTALK_CI_VMS}/${SMALLTALK}" > /dev/null
    download_file "get.pharo.org/${PHARO_GET_VM}" | bash
    popd > /dev/null
    # Make sure vm is now available
    [[ -f "${PHARO_VM}" ]] || exit 1
    print_timed_result "Time to download ${SMALLTALK} vm"
fi
# ==============================================================================

# Prepare image and virtual machine
# ==============================================================================
print_info "Preparing image..."
cp "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE}" "${SMALLTALK_CI_BUILD}"
cp "${SMALLTALK_CI_CACHE}/${PHARO_CHANGES}" "${SMALLTALK_CI_BUILD}"
# ==============================================================================

# ==============================================================================
# Load project and run tests
# ==============================================================================
print_info "Loading project..."
"${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" eval --save "
Metacello new 
    baseline: '${baseline}';
    repository: 'filetree://${project_home}/${packages}';
    load: '${baseline_group}'.
"

print_info "Run tests..."
"${PHARO_VM}" "${SMALLTALK_CI_BUILD}/${PHARO_IMAGE}" test --junit-xml-output --fail-on-failure "${tests}" 2>&1 || exit_status=$?
# ==============================================================================
