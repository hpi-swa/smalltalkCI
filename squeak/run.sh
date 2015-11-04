#!/bin/bash

set -e

# Set paths and files
# ==============================================================================
VM_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts/filetreeci/vms"
IMAGE_DOWNLOAD="https://www.hpi.uni-potsdam.de/hirschfeld/artefacts/filetreeci/images"

# Optional environment variables
[[ -z "$EXCLUDE_CATEGORIES" ]] && EXCLUDE_CATEGORIES="nil"
[[ -z "$EXCLUDE_CLASSES" ]] && EXCLUDE_CLASSES="nil"
[[ -z "$FORCE_UPDATE" ]] && FORCE_UPDATE="false"
[[ -z "$KEEP_OPEN" ]] && KEEP_OPEN="false"
if [[ -z "$RUN_SCRIPT" ]]; then
    RUN_SCRIPT="$SMALLTALK_CI_HOME/squeak/run.st"
else
    RUN_SCRIPT="$PROJECT_HOME/$RUN_SCRIPT"
fi
# ==============================================================================

# Check and specify Squeak image
# ==============================================================================
SPUR_IMAGE=true
case "$SMALLTALK" in
    "Squeak-trunk"|"Squeak-Trunk"|"SqueakTrunk")
        IMAGE_TAR="Squeak-Trunk.tar.gz"
        ;;
    "Squeak-5.0"|"Squeak5.0")
        IMAGE_TAR="Squeak-5.0.tar.gz"
        ;;
    "Squeak-4.6"|"Squeak4.6")
        IMAGE_TAR="Squeak-4.6.tar.gz"
        SPUR_IMAGE=false
        ;;
    "Squeak-4.5"|"Squeak4.5")
        IMAGE_TAR="Squeak-4.5.tar.gz"
        SPUR_IMAGE=false
        ;;
    *)
        print_error "Unsupported Squeak version '${SMALLTALK}'"
        exit 1
        ;;
esac
# ==============================================================================

# Identify OS and select virtual machine
# ==============================================================================
COG_VM_PARAM=""
case "$(uname -s)" in
    "Linux")
        print_info "Linux detected..."
        if [[ "$SPUR_IMAGE" = true ]]; then
            COG_VM_FILE_BASE="cog_linux_spur"
            COG_VM="$SMALLTALK_CI_VMS/cogspurlinux/bin/squeak"
        else
            COG_VM_FILE_BASE="cog_linux"
            COG_VM="$SMALLTALK_CI_VMS/coglinux/bin/squeak"
        fi
        COG_VM_FILE="$COG_VM_FILE_BASE.tar.gz"
        if [[ "$TRAVIS" = "true" ]]; then
            COG_VM_FILE="$COG_VM_FILE_BASE.min.tar.gz"
            COG_VM_PARAM="-nosound -nodisplay"
        fi
        ;;
    "Darwin")
        print_info "OS X detected..."
        if [[ "$SPUR_IMAGE" = true ]]; then
            COG_VM_FILE_BASE="cog_osx_spur"
            COG_VM="$SMALLTALK_CI_VMS/CogSpur.app/Contents/MacOS/Squeak"
        else
            COG_VM_FILE_BASE="cog_osx"
            COG_VM="$SMALLTALK_CI_VMS/Cog.app/Contents/MacOS/Squeak"
        fi
        COG_VM_FILE="$COG_VM_FILE_BASE.tar.gz"
        ;;
    *)
        print_error "Unsupported platform '$(uname -s)'"
        exit 1
        ;;
esac
# ==============================================================================

# Download files accordingly if not available
# ==============================================================================
if [[ ! -f "$SMALLTALK_CI_CACHE/$COG_VM_FILE" ]]; then
    print_info "Downloading virtual machine..."
    curl -s "$VM_DOWNLOAD/$COG_VM_FILE" > "$SMALLTALK_CI_CACHE/$COG_VM_FILE"
fi
if [[ ! -f "$COG_VM" ]]; then
    print_info "Extracting virtual machine..."
    tar xzf "$SMALLTALK_CI_CACHE/$COG_VM_FILE" -C "$SMALLTALK_CI_VMS"
fi
if [[ ! -f "$SMALLTALK_CI_CACHE/$IMAGE_TAR" ]]; then
    print_info "Downloading $SMALLTALK testing image..."
    curl -s "$IMAGE_DOWNLOAD/$IMAGE_TAR" > "$SMALLTALK_CI_CACHE/$IMAGE_TAR"
fi
# ==============================================================================

# Extract image and run on virtual machine
# ==============================================================================
print_info "Extracting image..."
tar xzf "$SMALLTALK_CI_CACHE/$IMAGE_TAR" -C "$SMALLTALK_CI_BUILD"

print_info "Load project into image and run tests..."
VM_ARGS="$RUN_SCRIPT $PACKAGES $BASELINE $BASELINE_GROUP $EXCLUDE_CATEGORIES $EXCLUDE_CLASSES $FORCE_UPDATE $KEEP_OPEN"
"$COG_VM" $COG_VM_PARAM "$SMALLTALK_CI_IMAGE" $VM_ARGS || EXIT_STATUS=$?
# ==============================================================================
