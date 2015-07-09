#!/bin/bash

set -e

[ -z "$FILETREE_CI_HOME" ] && FILETREE_CI_HOME="$(pwd)"

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
VM_DOWNLOAD="http://www.mirandabanda.org/files/Cog/VM/VM.r3397"
IMAGE_DOWNLOAD="https://inbox.fniephaus.com/image.tar.gz"
IMAGE_TAR="image.tar.gz"

case "$(uname -s)" in
    "Linux")
        echo "Linux detected..."
        COG_VM_FILE="coglinux-15.27.3397.tgz"
        COG_VM_PATH="$VM_PATH/coglinux/bin/squeak"
        COG_VM_PARAM="-nosound \
        -plugins "$VM_PATH/coglinux/lib/squeak/4.5-3370" \
        -encoding latin1 \
        -headless"
        ;;
    "Darwin")
        echo "OS X detected..."
        COG_VM_FILE="Cog.app-15.27.3397.tgz"
        COG_VM_PATH="$VM_PATH/Cog.app/Contents/MacOS/Squeak"
        COG_VM_PARAM="-headless"
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
    echo "Downloading testing image..."
    curl -s "$IMAGE_DOWNLOAD" > "$CACHE_PATH/$IMAGE_TAR"
fi
echo "Extracting image..."
tar xzf "$CACHE_PATH/$IMAGE_TAR" -C "$BUILD_PATH"

echo "Starting tests..."
"$COG_VM_PATH" $COG_VM_PARAM "$BUILD_PATH/TravisCI.image" "$SCRIPTS_PATH/run.st" "$BASELINE"

echo "Results:"
cd "$BUILD_PATH"
for f in ./*txt
do
   echo "[Start $f ]"
   cat -n "$f"
   echo "[End $f ]"
done

echo "Cleaning up..."
rm -rf "$BUILD_PATH" "$VM_PATH"

echo "Done!"