#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"
source "${BASE}/squeak/run.sh"

test_prepare_build() {
  $(squeak::prepare_build "GemStone" 2>/dev/null) \
      && fail "Should not be successful."
}

test_get_vm_details() {
  local config_smalltalk
  local vm_binary
  local vm_details
  local vm_filename
  local vm_path

  config_smalltalk="Squeak-4.6"
  vm_details="$(squeak::get_vm_details "Linux")"
  set_vars vm_filename vm_path vm_binary "${vm_details}"
  assertEquals "Cog-4.5-3427-VM-Linux.zip" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/Cog-4.5-3427/squeak" "${vm_binary}"

  config_smalltalk="Squeak-4.6"
  vm_details="$(squeak::get_vm_details "Darwin")"
  set_vars vm_filename vm_path vm_binary "${vm_details}"
  assertEquals "Cog-4.5-3427-VM-macOS.zip" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/Cog-4.5-3427/Cog.app/Contents/MacOS/Squeak" \
      "${vm_binary}"

  config_smalltalk="Squeak-5.1"
  vm_details="$(squeak::get_vm_details "Linux")"
  set_vars vm_filename vm_path vm_binary "${vm_details}"
  assertEquals "${config_smalltalk}-VM-Linux.zip" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/${config_smalltalk}/squeak" \
      "${vm_binary}"

  config_smalltalk="Squeak-5.1"
  vm_details="$(squeak::get_vm_details "CYGWIN_NT-123")"
  set_vars vm_filename vm_path vm_binary "${vm_details}"
  assertEquals "${config_smalltalk}-VM-Windows.zip" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/${config_smalltalk}/SqueakConsole.exe" \
      "${vm_binary}"

  config_smalltalk="Squeak64-5.1"
  vm_details="$(squeak::get_vm_details "Darwin")"
  set_vars vm_filename vm_path vm_binary "${vm_details}"
  assertEquals "${config_smalltalk}-VM-macOS.zip" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/${config_smalltalk}/CogSpur.app/Contents/MacOS/Squeak" \
      "${vm_binary}"

  set +e
  $(filename="$(squeak::get_vm_details "Linux" 2>/dev/null)") \
      || fail "'Linux' should be successful."
  $(filename="$(squeak::get_vm_details "" 2>/dev/null)") \
      && fail "Empty string should not be successful."
  $(filename="$(squeak::get_vm_details "Windows" 2>/dev/null)") \
      && fail "'Windows' should not be successful."
  set -e
}

source "${BASE}/lib/shunit2"
