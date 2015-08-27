#!/bin/bash

set -e

# Helper functions
# ==============================================================================
function print_info {
    printf "\e[0;34m$1\e[0m\n"
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
if [ -z "$1" ]; then
    print_error "No Squeak platform specified!"
    exit 1
fi
SMALLTALK=$1
# ==============================================================================

[ -z "$DISABLE_UPDATE" ] && DISABLE_UPDATE="false"

BASE_PATH="$(pwd)"
CACHE_PATH="$BASE_PATH/cache"
BUILD_BASE="$BASE_PATH/builds"
BUILD_ID="$(date "+%Y_%m_%d_%H_%M_%S")"
BUILD_PATH="$BUILD_BASE/$BUILD_ID"
VM_PATH="$CACHE_PATH/vms"
VM_DOWNLOAD="https://squeak.fniephaus.com"
IMAGE_PATH="$BASE_PATH/image"
SCRIPTS_PATH="$BASE_PATH/scripts"

# Select platform
# ==============================================================================
SPUR_IMAGE=false
case "$SMALLTALK" in
    "SqueakTrunk")
        IMAGE_URL="http://build.squeak.org/job/Trunk/default/lastSuccessfulBuild/artifact/target/"
        IMAGE_ARCHIVE="TrunkImage.zip"
        IMAGE_FILE="SpurTrunkImage.image"
        SOURCES_URL="http://ftp.squeak.org/sources_files/"
        SOURCES_ARCHIVE="SqueakV50.sources.gz"
        SOURCES_FILE="SqueakV50.sources"
        SPUR_IMAGE=true
        print_info "Updates disabled during this build..."
        DISABLE_UPDATE="true"
        ;;
    "Squeak5.0")
        IMAGE_URL="http://ftp.squeak.org/5.0/"
        IMAGE_ARCHIVE="Squeak5.0-15113.zip"
        IMAGE_FILE="Squeak5.0-15113.image"
        SOURCES_URL="http://ftp.squeak.org/sources_files/"
        SOURCES_ARCHIVE="SqueakV50.sources.gz"
        SOURCES_FILE="SqueakV50.sources"
        SPUR_IMAGE=true
        ;;
    "Squeak4.6")
        IMAGE_URL="http://ftp.squeak.org/4.6/"
        IMAGE_ARCHIVE="Squeak4.6-15102.zip"
        IMAGE_FILE="Squeak4.6-15102.image"
        SOURCES_URL="http://ftp.squeak.org/sources_files/"
        SOURCES_ARCHIVE="SqueakV46.sources.gz"
        SOURCES_FILE="SqueakV46.sources"
        ;;
    "Squeak4.5")
        IMAGE_URL="http://ftp.squeak.org/4.5/"
        IMAGE_ARCHIVE="Squeak4.5-13680.zip"
        IMAGE_FILE="Squeak4.5-13680.image"
        SOURCES_URL="http://ftp.squeak.org/sources_files/"
        SOURCES_ARCHIVE="SqueakV41.sources.gz"
        SOURCES_FILE="SqueakV41.sources"
        ;;
    *)
        print_error "$SMALLTALK is no supported! :("
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


print_info "Preparing folders..."
[[ -d "$CACHE_PATH" ]] || mkdir "$CACHE_PATH"
[[ -d "$BUILD_BASE" ]] || mkdir "$BUILD_BASE"
[[ -d "$VM_PATH" ]] || mkdir "$VM_PATH"
# Create folder for this build (should not exist)
mkdir "$BUILD_PATH"

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
if [ ! -f "$CACHE_PATH/$IMAGE_ARCHIVE" ]; then
    print_info "Downloading $IMAGE_ARCHIVE from $IMAGE_URL..."
    curl -s "$IMAGE_URL$IMAGE_ARCHIVE" > "$CACHE_PATH/$IMAGE_ARCHIVE"
fi
if [ ! -f "$CACHE_PATH/$SOURCES_ARCHIVE" ]; then
    print_info "Downloading $SOURCES_ARCHIVE from $SOURCES_URL..."
    curl -s "$SOURCES_URL$SOURCES_ARCHIVE" > "$CACHE_PATH/$SOURCES_ARCHIVE"
fi
# ==============================================================================

# Extract image and run on virtual machine
# ==============================================================================
print_info "Extracting image..."
tar xf "$CACHE_PATH/$IMAGE_ARCHIVE" -C "$BUILD_PATH"
print_info "Extracting sources file..."
wget http://ftp.squeak.org/sources_files/SqueakV50.sources.gz
gunzip SqueakV50.sources.gz
mv *.sources $BUILD_PATH

print_info "Preparing image for CI..."
"$COG_VM_PATH" "$BUILD_PATH/$IMAGE_FILE" "$SCRIPTS_PATH/prepare.st" "$SCRIPTS_PATH" "$DISABLE_UPDATE"

printf "\n"
print_info "Exporting image..."
cd "$BUILD_PATH"
tar czf "$BUILD_BASE/$SMALLTALK.tar.gz" TravisCI.image TravisCI.changes "$SOURCES_FILE"

print_info "Done!"