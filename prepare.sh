#!/bin/bash

set -e

if [ -z "$1" ]
  then
    echo "No image name provided"
fi

BASE_PATH="$(pwd)"
TMP_PATH="$BASE_PATH/tmp"
BUILD_PATH="$BASE_PATH/build"
IMAGE_PATH="$BASE_PATH/image"
SCRIPTS_PATH="$BASE_PATH/scripts"
VM_PATH="$BASE_PATH/vm"
IMAGE_TAR="$1.tar.gz"

echo "Preparing folders..."
mkdir "$TMP_PATH" "$BUILD_PATH"

echo "Copying files to temporary folder..."
cp -r "$IMAGE_PATH/" "$TMP_PATH/"
cp -r "$SCRIPTS_PATH" "$TMP_PATH/scripts"

echo "Preparing image for CI..."
"$VM_PATH/Cog.app/Contents/MacOS/Squeak" "$TMP_PATH/$1" "$TMP_PATH/scripts/prepare.st"

echo "Exporting image..."
mv "$TMP_PATH/"{TravisCI.image,TravisCI.changes,*.sources} "$BUILD_PATH"
cd "$BUILD_PATH"
tar czf "$BASE_PATH/$IMAGE_TAR" .

echo "Cleaning up..."
rm -rf "$TMP_PATH"

echo "Done!"