#!/bin/bash

set -e

function print_info {
    printf "\e[0;34m$1\e[0m\n"
}

BASE_PATH="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
CACHE_PATH="$BASE_PATH/_cache"
BUILD_BASE="$BASE_PATH/_builds"

print_info "Cleaning up..."
rm -rf "$CACHE_PATH" "$BUILD_BASE"

print_info "Done!"