#!/bin/bash

set -e

# Determine Pharo download url
# ==============================================================================
case "$SMALLTALK" in
    "Pharo-alpha")
        PHARO_GET_IMAGE="alpha"
        PHARO_GET_VM="vm50"
        ;;
    "Pharo-stable")
        PHARO_GET_IMAGE="stable"
        PHARO_GET_VM="vm50"
        ;;
    "Pharo-5.0")
        PHARO_GET_IMAGE="50"
        PHARO_GET_VM="vm50"
        ;;
    "Pharo-4.0")
        PHARO_GET_IMAGE="40"
        PHARO_GET_VM="vm40"
        ;;
    "Pharo-3.0")
        PHARO_GET_IMAGE="30"
        PHARO_GET_VM="vm30"
        ;;
    *)
        print_error "Unsupported Pharo version '${SMALLTALK}'"
        exit 1
        ;;
esac
# ==============================================================================
 
# Set paths and files
# ==============================================================================
PHARO_IMAGE="$SMALLTALK.image"
PHARO_CHANGES="$SMALLTALK.changes"
if [[ "$TRAVIS" = "true" ]]; then
    PHARO_VM="$FILETREE_CI_VMS/$SMALLTALK/pharo"
else
    PHARO_VM="$FILETREE_CI_VMS/$SMALLTALK/pharo-ui"
fi

# Optional environment variables
[[ -z "$BASELINE_GROUP" ]] && BASELINE_GROUP="default"
[[ -z "$PACKAGES" ]] && PACKAGES=""
[[ -z "$TESTS" ]] && TESTS="${BASELINE}.*"
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "$FILETREE_CI_CACHE/$PHARO_IMAGE" ]]; then
    print_info "Downloading $SMALLTALK image..."
    pushd "$FILETREE_CI_CACHE" > /dev/null
    wget --quiet -O - get.pharo.org/${PHARO_GET_IMAGE} | bash
    mv Pharo.image "$SMALLTALK.image"
    mv Pharo.changes "$SMALLTALK.changes"
    popd > /dev/null
fi

if [[ ! -d "$FILETREE_CI_VMS/$SMALLTALK" ]]; then
    print_info "Downloading $SMALLTALK vm..."
    mkdir "$FILETREE_CI_VMS/$SMALLTALK"
    pushd "$FILETREE_CI_VMS/$SMALLTALK" > /dev/null
    wget --quiet -O - get.pharo.org/${PHARO_GET_VM} | bash
    # Remove libFT2Plugin if present
    rm -f "$FILETREE_CI_VMS/$SMALLTALK/pharo-vm/libFT2Plugin.so"
    popd > /dev/null
    # Make sure vm is now available
    [[ -f "$PHARO_VM" ]] || exit 1
fi
# ==============================================================================

# Prepare image and virtual machine
# ==============================================================================
print_info "Preparing image..."
cp "$FILETREE_CI_CACHE/$PHARO_IMAGE" "$FILETREE_CI_BUILD"
cp "$FILETREE_CI_CACHE/$PHARO_CHANGES" "$FILETREE_CI_BUILD"
# ==============================================================================

# ==============================================================================
# Load project and run tests
# ==============================================================================
print_info "Loading project..."
$PHARO_VM "$FILETREE_CI_BUILD/$PHARO_IMAGE" eval --save "
Metacello new 
    baseline: '${BASELINE}';
    repository: 'filetree://${PROJECT_HOME}${PACKAGES}';
    load: '${BASELINE_GROUP}'.
"

print_info "Run tests..."
EXIT_STATUS=0
$PHARO_VM "$FILETREE_CI_BUILD/$PHARO_IMAGE" test --fail-on-failure "$TESTS" 2>&1 || EXIT_STATUS=$?
# ==============================================================================

exit $EXIT_STATUS
