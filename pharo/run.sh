#!/bin/bash

set -e

# Determine Pharo download url
# ==============================================================================
case "${SMALLTALK}" in
    "Pharo-alpha")
        readonly pharo_get_image="alpha"
        readonly pharo_get_vm="vm50"
        ;;
    "Pharo-stable")
        readonly pharo_get_image="stable"
        readonly pharo_get_vm="vm40"
        ;;
    "Pharo-5.0")
        readonly pharo_get_image="50"
        readonly pharo_get_vm="vm50"
        ;;
    "Pharo-4.0")
        readonly pharo_get_image="40"
        readonly pharo_get_vm="vm40"
        ;;
    "Pharo-3.0")
        readonly pharo_get_image="30"
        readonly pharo_get_vm="vm30"
        ;;
    *)
        print_error "Unsupported Pharo version '${SMALLTALK}'"
        exit 1
        ;;
esac
# ==============================================================================
 
# Set paths and files
# ==============================================================================
readonly pharo_image="${SMALLTALK}.image"
readonly pharo_changes="${SMALLTALK}.changes"
if [[ "${keep_open}" = "true" ]]; then
    readonly pharo_vm="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo-ui"
else
    readonly pharo_vm="${SMALLTALK_CI_VMS}/${SMALLTALK}/pharo"
fi

# Make sure options are set
[[ -z "${baseline_group}" ]] && baseline_group="default"
[[ -z "${packages}" ]] && packages=""
[[ -z "${tests}" ]] && tests="${baseline}.*"
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "${SMALLTALK_CI_CACHE}/${pharo_image}" ]]; then
    print_timed "Downloading ${SMALLTALK} image..."
    pushd "${SMALLTALK_CI_CACHE}" > /dev/null
    download_file "get.pharo.org/${pharo_get_image}" | bash
    mv Pharo.image "${SMALLTALK}.image"
    mv Pharo.changes "${SMALLTALK}.changes"
    popd > /dev/null
    print_timed_result "Time to download ${SMALLTALK} image"
fi

if [[ ! -d "${SMALLTALK_CI_VMS}/${SMALLTALK}" ]]; then
    print_timed "Downloading ${SMALLTALK} vm..."
    mkdir "${SMALLTALK_CI_VMS}/${SMALLTALK}"
    pushd "${SMALLTALK_CI_VMS}/${SMALLTALK}" > /dev/null
    download_file "get.pharo.org/${pharo_get_vm}" | bash
    popd > /dev/null
    # Make sure vm is now available
    [[ -f "${pharo_vm}" ]] || exit 1
    print_timed_result "Time to download ${SMALLTALK} vm"
fi
# ==============================================================================

# Prepare image and virtual machine
# ==============================================================================
print_info "Preparing image..."
cp "${SMALLTALK_CI_CACHE}/${pharo_image}" "${SMALLTALK_CI_BUILD}"
cp "${SMALLTALK_CI_CACHE}/${pharo_changes}" "${SMALLTALK_CI_BUILD}"
# ==============================================================================

# ==============================================================================
# Load project and run tests
# ==============================================================================
print_info "Loading project..."
"${pharo_vm}" "${SMALLTALK_CI_BUILD}/${pharo_image}" eval --save "
Metacello new 
    baseline: '${baseline}';
    repository: 'filetree://${project_home}/${packages}';
    load: '${baseline_group}'.
"

print_info "Run tests..."
"${pharo_vm}" "${SMALLTALK_CI_BUILD}/${pharo_image}" test --junit-xml-output --fail-on-failure "${tests}" 2>&1 || exit_status=$?
# ==============================================================================
