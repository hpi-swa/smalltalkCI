#!/bin/bash

set -e

# Include helper functions
source helpers.sh

readonly BASE_PATH="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
readonly CACHE_PATH="${BASE_PATH}/_cache"
readonly BUILD_BASE="${BASE_PATH}/_builds"

print_info "Cleaning up..."
rm -rf "${CACHE_PATH}" "${BUILD_BASE}"

print_info "Done!"