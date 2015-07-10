#!/bin/bash

set -e

[ -z "$FILETREE_CI_HOME" ] && FILETREE_CI_HOME="$(pwd)"
[ -z "$PACKAGES" ] && PACKAGES="/packages"

if [ -z "$SMALLTALK" ]; then
    echo "\$SMALLTALK needs to be set"
    exit 1
fi

if [ -z "$PROJECT_HOME" ]; then
    echo "\$PROJECT_HOME needs to be set"
    exit 1
fi

if [ -z "$BASELINE" ]; then
    echo "\$BASELINE needs to be set"
    exit 1
fi 

BASE_PATH="$FILETREE_CI_HOME"
CACHE_PATH="$BASE_PATH/cache"
BUILD_PATH="$BASE_PATH/build"
GIT_PATH="$BUILD_PATH/git_cache"
SCRIPTS_PATH="$BASE_PATH/scripts"
VM_PATH="$BASE_PATH/vm"
VM_TAR="vm.tar.gz"
VM_DOWNLOAD="https://inbox.fniephaus.com"
IMAGE_TAR="$SMALLTALK.tar.gz"
IMAGE_DOWNLOAD="https://inbox.fniephaus.com/$IMAGE_TAR"

COG_VM_PARAM=""
case "$(uname -s)" in
    "Linux")
        echo "Linux detected..."
        COG_VM_FILE="cog_linux.tar.gz"
        COG_VM_PATH="$VM_PATH/coglinux/bin/squeak"
        COG_VM_PARAM="-headless"
        ;;
    "Darwin")
        echo "OS X detected..."
        COG_VM_FILE="cog_osx.tar.gz"
        COG_VM_PATH="$VM_PATH/Cog.app/Contents/MacOS/Squeak"
        ;;
    *)
        echo "$(basename $0): unknown platform $(uname -s)"
        exit 1
        ;;
esac

echo "Preparing folders..."
mkdir "$BUILD_PATH" "$VM_PATH"
if [ ! -d "$CACHE_PATH" ]; then
    mkdir "$CACHE_PATH"
fi
ln -s $PROJECT_HOME $GIT_PATH

if [ ! -f "$CACHE_PATH/$VM_TAR" ]; then
    echo "Downloading virtual machine..."
    curl -s "$VM_DOWNLOAD/$COG_VM_FILE" > "$CACHE_PATH/$VM_TAR"
fi
echo "Extracting virtual machine..."
tar xzf "$CACHE_PATH/$VM_TAR" -C "$VM_PATH"

if [ ! -f "$CACHE_PATH/$IMAGE_TAR" ]; then
    echo "Downloading $SMALLTALK testing image..."
    curl -s "$IMAGE_DOWNLOAD" > "$CACHE_PATH/$IMAGE_TAR"
fi
echo "Extracting image..."
tar xzf "$CACHE_PATH/$IMAGE_TAR" -C "$BUILD_PATH"

echo "Starting image..."
EXIT_STATUS=0
"$COG_VM_PATH" $COG_VM_PARAM "$BUILD_PATH/TravisCI.image" "$SCRIPTS_PATH/run.st" "$BASELINE" "$PACKAGES" || EXIT_STATUS=$?

echo "Cleaning up..."
rm -rf "$BUILD_PATH" "$VM_PATH"

echo "Done!"

exit $EXIT_STATUS