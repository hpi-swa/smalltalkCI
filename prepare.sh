#!/bin/bash

set -e

BASE_PATH="$(pwd)"
TMP_PATH="$BASE_PATH/tmp"
BUILD_PATH="$BASE_PATH/build"
IMAGE_PATH="$BASE_PATH/image"
SCRIPTS_PATH="$BASE_PATH/scripts"
VM_PATH="$BASE_PATH/vm"

echo "Preparing folders..."
mkdir "$TMP_PATH" "$BUILD_PATH"

echo "Copying files to temporary folder..."
cp -r "$IMAGE_PATH/" "$TMP_PATH/"
cp -r "$SCRIPTS_PATH" "$TMP_PATH/scripts"

echo "Preparing image for CI..."
"$VM_PATH/Cog.app/Contents/MacOS/Squeak" "$TMP_PATH/TrunkImage.image" "$TMP_PATH/scripts/prepare.st"

echo "Exporting image..."
mv "$TMP_PATH/"{TravisCI.image,TravisCI.changes,*.sources} "$BUILD_PATH"
tar czf build.tar.gz ./build

echo "Cleaning up..."
rm -rf "$TMP_PATH"

echo "Done!"