#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"
source "${BASE}/squeak/run.sh"

test_prepare_build() {
  $(squeak::prepare_build "GemStone" 2>/dev/null) \
      && fail "Should not be successful."
}

test_get_vm_details() {
  local vm_details
  local vm_filename
  local vm_path

  vm_details="$(squeak::get_vm_details "Linux" 1)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "squeak.cog.spur_linux32x86_15.33.3427.tar.gz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/cogspurlinux/squeak" "${vm_path}"

  vm_details="$(squeak::get_vm_details "Linux" 0)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "squeak.cog.v3_linux32x86_15.33.3427.tar.gz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/coglinux/squeak" "${vm_path}"

  vm_details="$(squeak::get_vm_details "Darwin" 1)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "squeak.cog.spur_macos32x86_15.33.3427.tar.gz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak" \
      "${vm_path}"

  vm_details="$(squeak::get_vm_details "Darwin" 0)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "squeak.cog.v3_macos32x86_15.33.3427.tar.gz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak" "${vm_path}"

  set +e
  $(filename="$(squeak::get_vm_details "Linux" 2>/dev/null)") \
      || fail "Should be successful."
  $(filename="$(squeak::get_vm_details "" 2>/dev/null)") \
      && fail "Should not be successful."
  $(filename="$(squeak::get_vm_details "Windows" 2>/dev/null)") \
      && fail "Should not be successful."
  set -e
}

source "${BASE}/lib/shunit2"
