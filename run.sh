#!/bin/bash

set -e

# Helper functions
# ==============================================================================
function print_info {
    printf "\e[0;34m%s\e[0m\n" "$1"
}

function print_notice {
    printf "\e[1;33m%s\e[0m\n" "$1"
}

function print_success {
    printf "\e[1;32m%s\e[0m\n" "$1"
}

function print_error {
    printf "\e[1;31m%s\e[0m\n" "$1" 1>&2
}
# ==============================================================================

# Check required software
# ==============================================================================
case "$(uname -s)" in
    "Linux"|"Darwin")
        ;;
    *)
        print_error "Unsupported platform '$(uname -s)'"
        exit 1
        ;;
esac
if [[ ! $(which curl 2> /dev/null) ]]; then
    print_error "Please install curl."
    exit 1
fi
# ==============================================================================

# Check required environment variables
# ==============================================================================
if [[ -z "$PROJECT_HOME" ]]; then
    print_error "\$PROJECT_HOME is not defined."
    exit 1
elif [[ -z "$BASELINE" ]]; then
    print_error "\$BASELINE is not defined."
    exit 1
fi
# ==============================================================================

# Check optional environment variables
# ==============================================================================
[[ -z "$PACKAGES" ]] && export PACKAGES="/packages"
[[ -z "$BASELINE_GROUP" ]] && export BASELINE_GROUP="TravisCI"
# ==============================================================================

# Set default Smalltalk version
# ==============================================================================
[[ -z "$SMALLTALK" ]] && export SMALLTALK="Squeak-5.0"
# ==============================================================================

# Make sure smalltalkCI home directory is set
# ==============================================================================
if [[ -z "$SMALLTALK_CI_HOME" ]] && [[ "$TRAVIS" != "true" ]]; then
    export SMALLTALK_CI_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SMALLTALK_CI_HOME/env_vars"
fi
# ==============================================================================

# Prepare folders
# ==============================================================================
print_info "Preparing folders..."
[[ -d "$SMALLTALK_CI_CACHE" ]] || mkdir "$SMALLTALK_CI_CACHE"
[[ -d "$SMALLTALK_CI_BUILD_BASE" ]] || mkdir "$SMALLTALK_CI_BUILD_BASE"
[[ -d "$SMALLTALK_CI_VMS" ]] || mkdir "$SMALLTALK_CI_VMS"
# Create folder for this build (should not exist)
mkdir "$SMALLTALK_CI_BUILD"
# Link project folder to git_cache
ln -s "$PROJECT_HOME" "$SMALLTALK_CI_GIT"
# ==============================================================================

# Start build accordingly
# ==============================================================================
EXIT_STATUS=0
case "$SMALLTALK" in
    Squeak*)
        print_info "Starting Squeak build..."
        source "$SMALLTALK_CI_HOME/squeak/run.sh" || EXIT_STATUS=$?
        ;;
    Pharo*)
        print_info "Starting Pharo build..."
        source "$SMALLTALK_CI_HOME/pharo/run.sh" || EXIT_STATUS=$?
        ;;
    *)
        print_error "Unknown Smalltalk version '${SMALLTALK}'"
        exit 1
        ;;
esac
# ==============================================================================

# Check exit status
# ==============================================================================
printf "\n\n"
if [[ $EXIT_STATUS -eq 0 ]]; then
    print_success "Build successful :)"
else
    print_error "Build failed :("
    if [[ "$TRAVIS" = "true" ]]; then
        printf "\n\n"
        print_info "To reproduce the failed build locally, download smalltalkCI and try running something like:"
        printf "\n"
        print_notice "SMALLTALK=$SMALLTALK BASELINE=$BASELINE BASELINE_GROUP=$BASELINE_GROUP PROJECT_HOME=/local/path/to/project PACKAGES=$PACKAGES FORCE_UPDATE=$FORCE_UPDATE KEEP_OPEN=true ./run.sh"
        printf "\n"
    fi
fi
printf "\n"
# ==============================================================================

exit $EXIT_STATUS
