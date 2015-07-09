#!/bin/bash

set -e

BASE_PATH="$(pwd)"
TMP_PATH="$BASE_PATH/tmp"
BUILD_PATH="$BASE_PATH/build"
SCRIPTS_PATH="$BASE_PATH/scripts"
VM_PATH="$BASE_PATH/vm"
DOWNLOAD_PATH="http://www.mirandabanda.org/files/Cog/VM/VM.r3397"

case "$(uname -s)" in
    "Linux")
        echo "Linux detected..."
        COG_VM_FILE="coglinux-15.27.3397.tgz"
        COG_VM_PATH="$VM_PATH/bin/squeak"
        ;;
    "Darwin")
        echo "OS X detected..."
        COG_VM_FILE="Cog.app-15.27.3397.tgz"
        COG_VM_PATH="$VM_PATH/Cog.app/Contents/MacOS/Squeak"
        ;;
    *)
        echo "$(basename $0): unknown platform $(uname -s)"
        exit 1
        ;;
esac

echo "Preparing folders..."
mkdir "$TMP_PATH" "$VM_PATH"

echo "Downloading virtual machine..."
curl -s "$DOWNLOAD_PATH/$COG_VM_FILE" > "$TMP_PATH/vm.tar.gz"
tar -xzf "$TMP_PATH/vm.tar.gz" -C "$VM_PATH"

echo "Extracting image..."
tar xzf ./build.tar.gz

echo "Starting tests..."
{ time "$COG_VM_PATH" "$BUILD_PATH/TravisCI.image" "$SCRIPTS_PATH/run.st" ; } 2> "$BUILD_PATH/time.txt"

echo "Cleaning up..."
rm -rf "$TMP_PATH"

echo "Results:"
cd "$BUILD_PATH"
for f in ./*txt
do
   echo "[Start $f ]"
   cat -n "$f"
   echo "[End $f ]"
done

echo "Done!"