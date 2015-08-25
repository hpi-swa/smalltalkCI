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

# Check required arguments
# ==============================================================================
if [ -z "$SMALLTALK" ]; then
    print_error "\$SMALLTALK is not defined!"
    exit 1
elif [ -z "$PROJECT_HOME" ]; then
    print_error "\$PROJECT_HOME is not defined!"
    exit 1
elif [ -z "$BASELINE" ]; then
    print_error "\$BASELINE is not defined!"
    exit 1
fi
# ==============================================================================

# Set paths and files
# ==============================================================================
if [ -z "$FILETREE_CI_HOME" ]; then
    FILETREE_CI_HOME="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
fi

BASE_PATH="$FILETREE_CI_HOME"
CACHE_PATH="$BASE_PATH/cache"
BUILD_BASE="$BASE_PATH/builds"
BUILD_ID="$(date "+%Y_%m_%d_%H_%M_%S")"
BUILD_PATH="$BUILD_BASE/$BUILD_ID"
GIT_PATH="$BUILD_PATH/git_cache"
VM_PATH="$CACHE_PATH/vms"
VM_DOWNLOAD="https://squeak.fniephaus.com"
VM_IMAGE_NAME="$BUILD_PATH/TravisCI.image"
IMAGE_TAR="$SMALLTALK.tar.gz"
IMAGE_DOWNLOAD="https://squeak.fniephaus.com/$IMAGE_TAR"

SPUR_IMAGE=false
case "$SMALLTALK" in
    "Squeak5.0" | "SqueakTrunk")
        SPUR_IMAGE=true
        ;;
esac

# Optional environment variables
[ -z "$PACKAGES" ] && PACKAGES="/packages"
[ -z "$BASELINE_GROUP" ] && BASELINE_GROUP="TravisCI"
[ -z "$EXCLUDE_CATEGORIES" ] && EXCLUDE_CATEGORIES="nil"
[ -z "$EXCLUDE_CLASSES" ] && EXCLUDE_CLASSES="nil"
[ -z "$FORCE_UPDATE" ] && FORCE_UPDATE="false"
[ -z "$KEEP_OPEN" ] && KEEP_OPEN="false"
if [ -z "$RUN_SCRIPT" ]; then
    RUN_SCRIPT="$BASE_PATH/run.st"
else
    RUN_SCRIPT="$PROJECT_HOME/$RUN_SCRIPT"
fi
# ==============================================================================

# Identify OS and select virtual machine
# ==============================================================================
COG_VM_PARAM=""
case "$(uname -s)" in
    "Linux")
        print_info "Linux detected..."
        if [ "$SPUR_IMAGE" = true ]; then
            COG_VM_FILE_BASE="cog_linux_spur"
            COG_VM_PATH="$VM_PATH/cogspurlinux/bin/squeak"
        else
            COG_VM_FILE_BASE="cog_linux"
            COG_VM_PATH="$VM_PATH/coglinux/bin/squeak"
        fi
        COG_VM_FILE="$COG_VM_FILE_BASE.tar.gz"
        if [ "$TRAVIS" = "true" ]; then
            COG_VM_FILE="$COG_VM_FILE_BASE.min.tar.gz"
            COG_VM_PARAM="-nosound -nodisplay"
        fi
        ;;
    "Darwin")
        print_info "OS X detected..."
        if [ "$SPUR_IMAGE" = true ]; then
            COG_VM_FILE_BASE="cog_osx_spur"
            COG_VM_PATH="$VM_PATH/CogSpur.app/Contents/MacOS/Squeak"
        else
            COG_VM_FILE_BASE="cog_osx"
            COG_VM_PATH="$VM_PATH/Cog.app/Contents/MacOS/Squeak"
        fi
        COG_VM_FILE="$COG_VM_FILE_BASE.tar.gz"
        ;;
    *)
        print_error "$(basename $0): unknown platform $(uname -s)"
        exit 1
        ;;
esac
# ==============================================================================

# Prepare folders
# ==============================================================================
print_info "Preparing folders..."
[[ -d "$CACHE_PATH" ]] || mkdir "$CACHE_PATH"
[[ -d "$BUILD_BASE" ]] || mkdir "$BUILD_BASE"
[[ -d "$VM_PATH" ]] || mkdir "$VM_PATH"
# Create folder for this build (should not exist)
mkdir "$BUILD_PATH"
# Link project folder to git_cache
ln -s "$PROJECT_HOME" "$GIT_PATH"
# ==============================================================================

# Perform optional steps
# ==============================================================================
if [ ! -f "$CACHE_PATH/$COG_VM_FILE" ]; then
    print_info "Downloading virtual machine..."
    curl -s "$VM_DOWNLOAD/$COG_VM_FILE" > "$CACHE_PATH/$COG_VM_FILE"
fi
if [ ! -f "$COG_VM_PATH" ]; then
    print_info "Extracting virtual machine..."
    tar xzf "$CACHE_PATH/$COG_VM_FILE" -C "$VM_PATH"
fi
if [ ! -f "$CACHE_PATH/$IMAGE_TAR" ]; then
    print_info "Downloading $SMALLTALK testing image..."
    curl -s "$IMAGE_DOWNLOAD" > "$CACHE_PATH/$IMAGE_TAR"
fi
# ==============================================================================

# Extract image and run on virtual machine
# ==============================================================================
print_info "Extracting image..."
tar xzf "$CACHE_PATH/$IMAGE_TAR" -C "$BUILD_PATH"

print_info "Load project into image and run tests..."
VM_ARGS="$RUN_SCRIPT $PACKAGES $BASELINE $BASELINE_GROUP $EXCLUDE_CATEGORIES $EXCLUDE_CLASSES $FORCE_UPDATE $KEEP_OPEN"
EXIT_STATUS=0
"$COG_VM_PATH" $COG_VM_PARAM $VM_IMAGE_NAME $VM_ARGS || EXIT_STATUS=$?
# ==============================================================================

printf "\n\n"
if [ $EXIT_STATUS -eq 0 ]; then
    print_success "Build successful :)"
else
    print_error "Build failed :("
    if [ "$TRAVIS" = "true" ]; then
        printf "\n\n"
        print_info "To reproduce the failed build locally, download filetreeCI and try running something like:"
        printf "\n"
        print_notice "SMALLTALK=$SMALLTALK BASELINE=$BASELINE BASELINE_GROUP=$BASELINE_GROUP PROJECT_HOME=/local/path/to/project PACKAGES=$PACKAGES FORCE_UPDATE=$FORCE_UPDATE KEEP_OPEN=true ./run.sh"
        printf "\n"
    fi
fi
printf "\n"

exit $EXIT_STATUS