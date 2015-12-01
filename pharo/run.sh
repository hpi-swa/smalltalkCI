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
    PHARO_VM="$SMALLTALK_CI_VMS/$SMALLTALK/pharo"
else
    PHARO_VM="$SMALLTALK_CI_VMS/$SMALLTALK/pharo-ui"
fi

# Optional environment variables
[[ -z "$BASELINE_GROUP" ]] && BASELINE_GROUP="default"
[[ -z "$PACKAGES" ]] && PACKAGES=""
[[ -z "$TESTS" ]] && TESTS="${BASELINE}.*"
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "$SMALLTALK_CI_CACHE/$PHARO_IMAGE" ]]; then
    print_info "Downloading $SMALLTALK image..."
    pushd "$SMALLTALK_CI_CACHE" > /dev/null
    wget --quiet -O - get.pharo.org/${PHARO_GET_IMAGE} | bash
    mv Pharo.image "$SMALLTALK.image"
    mv Pharo.changes "$SMALLTALK.changes"
    popd > /dev/null
fi

if [[ ! -d "$SMALLTALK_CI_VMS/$SMALLTALK" ]]; then
    print_info "Downloading $SMALLTALK vm..."
    mkdir "$SMALLTALK_CI_VMS/$SMALLTALK"
    pushd "$SMALLTALK_CI_VMS/$SMALLTALK" > /dev/null
    wget --quiet -O - get.pharo.org/${PHARO_GET_VM} | bash
    popd > /dev/null
    # Make sure vm is now available
    [[ -f "$PHARO_VM" ]] || exit 1
fi
# ==============================================================================

# Prepare image and virtual machine
# ==============================================================================
print_info "Preparing image..."
cp "$SMALLTALK_CI_CACHE/$PHARO_IMAGE" "$SMALLTALK_CI_BUILD"
cp "$SMALLTALK_CI_CACHE/$PHARO_CHANGES" "$SMALLTALK_CI_BUILD"
# ==============================================================================

# ==============================================================================
# Load project and run tests
# ==============================================================================
print_info "Loading project..."
$PHARO_VM "$SMALLTALK_CI_BUILD/$PHARO_IMAGE" eval --save "
Metacello new 
    baseline: '${BASELINE}';
    repository: 'filetree://${PROJECT_HOME}/${PACKAGES}';
    load: '${BASELINE_GROUP}'.
"

print_info "Run tests..."
$PHARO_VM "$SMALLTALK_CI_BUILD/$PHARO_IMAGE" test --fail-on-failure "$TESTS" 2>&1 || EXIT_STATUS=$?
# ==============================================================================
