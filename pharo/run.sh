#!/bin/bash

set -e

# Helper functions
# ==============================================================================
function print_info {
    printf "\e[0;34m$1\e[0m\n"
}

function print_notice {
    printf "\e[1;33m$1\e[0m\n"
}

function print_success {
    printf "\e[1;32m$1\e[0m\n"
}

function print_error {
    printf "\e[1;31m$1\e[0m\n"
}
# ==============================================================================

# Determine Pharo download url
# ==============================================================================
case "$SMALLTALK" in
    "Pharo-latest")
        PHARO_GET_VERSION="alpha"
        ;;
    "Pharo-stable")
        PHARO_GET_VERSION="stable"
        ;;
    "Pharo-5.0")
        PHARO_GET_VERSION="50"
        ;;
    "Pharo-4.0")
        PHARO_GET_VERSION="40"
        ;;
    #"Pharo-3.0")
    #    PHARO_GET_VERSION="30"
    #    ;;
    # "Pharo-2.0")
    #     PHARO_GET_VERSION="20"
    #     ;;
    *)
        print_error "Unsupported Pharo version ${SMALLTALK}"
        exit 1
        ;;
esac
# ==============================================================================

# Set paths and files
# ==============================================================================
PHARO_IMAGE="$SMALLTALK.image"
PHARO_CHANGES="$SMALLTALK.changes"
PHARO_VM="$FILETREE_CI_VMS/$SMALLTALK/pharo"
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [ ! -f "$FILETREE_CI_CACHE/$PHARO_IMAGE" ]; then
    print_info "Downloading $SMALLTALK image..."
    pushd $FILETREE_CI_CACHE > /dev/null
    wget --quiet -O - get.pharo.org/${PHARO_GET_VERSION}+vm | bash
    mv Pharo.image "$SMALLTALK.image"
    mv Pharo.changes "$SMALLTALK.changes"
    popd > /dev/null
fi

if [ ! -d "$FILETREE_CI_VMS/$SMALLTALK" ]; then
    print_info "Downloading $SMALLTALK vm..."
    mkdir "$FILETREE_CI_VMS/$SMALLTALK"
    pushd $FILETREE_CI_VMS/$SMALLTALK > /dev/null
    wget --quiet -O - get.pharo.org/vm${PHARO_GET_VERSION} | bash
    # Remove libFT2Plugin if present
    rm -f "$FILETREE_CI_VMS/$SMALLTALK/pharo-vm/libFT2Plugin.so"
    popd > /dev/null
    # Make sure vm is now available
    [ -f "$PHARO_VM" ] || exit 1
fi

# ==============================================================================

# Prepare image and virtual machine
# ==============================================================================
print_info "Preparing image..."
cp "$FILETREE_CI_CACHE/$PHARO_IMAGE" "$FILETREE_CI_BUILD"
cp "$FILETREE_CI_CACHE/$PHARO_CHANGES" "$FILETREE_CI_BUILD"

# ==============================================================================

# Load project and run tests
# ==============================================================================
print_info "Loading project..."
$PHARO_VM "$FILETREE_CI_BUILD/$PHARO_IMAGE" eval --save "
Metacello new 
    baseline: '${BASELINE}';
    repository: 'filetree://${PROJECT_HOME}/${PACKAGES}';
    load: '${BASELINE_GROUP}'.
"

print_info "Run tests..."
if [ "${TESTS}" = "" ]; then
    TESTS="${BASELINE}.*"
fi
EXIT_STATUS=0
$PHARO_VM "$FILETREE_CI_BUILD/$PHARO_IMAGE" test --fail-on-failure "${TESTS}" 2>&1 || EXIT_STATUS=$?
# ==============================================================================

exit $EXIT_STATUS
