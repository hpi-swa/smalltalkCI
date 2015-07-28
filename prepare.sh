#!/bin/bash

set -e

IMAGE=$1
CHANGES=$2
[ -z "$IMAGE" ] && IMAGE=TrunkImage
[ -z "$CHANGES" ] && CHANGES=SqueakV41.sources
[ -z "$DISABLE_UPDATE" ] && DISABLE_UPDATE="false"

# Disable updates in TrunkImage
if [ "$IMAGE" == 'TrunkImage' ]; then
    DISABLE_UPDATE="true"
fi

BASE_PATH="$(pwd)"
TMP_PATH="$BASE_PATH/tmp"
BUILD_PATH="$BASE_PATH/build"
IMAGE_PATH="$BASE_PATH/image"
SCRIPTS_PATH="$BASE_PATH/scripts"
VM_PATH="$BASE_PATH/vm"
IMAGE_TAR="$IMAGE.tar.gz"


echo "Preparing folders..."
mkdir "$TMP_PATH" "$BUILD_PATH"

echo "Copying files to temporary folder..."
cp -r "$IMAGE_PATH/" "$TMP_PATH/"
cp -r "$SCRIPTS_PATH" "$TMP_PATH/scripts"

echo "Preparing image for CI..."
"$VM_PATH/Cog.app/Contents/MacOS/Squeak" "$TMP_PATH/$IMAGE.image" "$TMP_PATH/scripts/prepare.st" "$DISABLE_UPDATE"

echo ""
echo "Exporting image..."
mv "$TMP_PATH/"{TravisCI.image,TravisCI.changes,"$CHANGES"} "$BUILD_PATH"
cd "$BUILD_PATH"
tar czf "$BASE_PATH/$IMAGE_TAR" .

echo "Cleaning up..."
cd "$BASE_PATH"
rm -rf "$TMP_PATH" "$BUILD_PATH"

echo "Done!"