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
    *)
        print_error "Unsupported Pharo version ${SMALLTALK}"
        exit 1
        ;;
esac

print_info "Downloading $SMALLTALK image..."
pushd $FILETREE_CI_CACHE > /dev/null
wget --quiet -O - get.pharo.org/${PHARO_GET_VERSION}+vm | bash
popd > /dev/null

# ==============================================================================
# Load project and run tests
# ==============================================================================
print_info "Loading project..."
./pharo Pharo.image eval --save "
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
./pharo Pharo.image test --fail-on-failure "${TESTS}" 2>&1 || EXIT_STATUS=$?
# ==============================================================================

exit $EXIT_STATUS
