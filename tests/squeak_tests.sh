#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"
source "${BASE}/squeak/run.sh"

assert_vm_filename() {
    if ! starts_with "$1" "$2"; then
        fail "Unexpected vm_filename: '$1'"
    fi
}

test_prepare_build() {
  $(squeak::prepare_build "GemStone" 2>/dev/null) \
      && fail "Should not be successful."
}

test_get_vm_details() {
  local vm_details
  local vm_filename
  local vm_path

  config_smalltalk="Squeak64-trunk"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Linux" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_linux64x64_"
  assertEquals "${config_vm_dir}/sqcogspur64linuxht/squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak64-6.0"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Linux" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_linux64x64_"
  assertEquals "${config_vm_dir}/sqcogspur64linuxht/squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak32-6.0"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Linux" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_linux32x86_"
  assertEquals "${config_vm_dir}/sqcogspur32linuxht/squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak64-5.3"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Linux" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_linux64x64_"
  assertEquals "${config_vm_dir}/sqcogspur64linuxht/squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak32-5.2"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Linux" 0)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.v3_linux32x86_itimer_"
  assertEquals "${config_vm_dir}/sqcoglinux/squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak64-5.3"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Darwin" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_macos64x64_"
  assertEquals "${config_vm_dir}/Squeak.app/Contents/MacOS/Squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak64-5.2"
  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Darwin" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_macos64x64_"
  assertEquals "${config_vm_dir}/Squeak.app/Contents/MacOS/Squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  config_smalltalk="Squeak64-trunk"

  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "Darwin" 0)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.v3_macos64x64_"
  assertEquals "${config_vm_dir}/Squeak.app/Contents/MacOS/Squeak" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "CYGWIN_NT-6.1" 1)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.spur_win64x64_"
  assertEquals "${config_vm_dir}/SqueakConsole.exe" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  vm_details="$(squeak::get_vm_details "${config_smalltalk}" "CYGWIN_NT-6.1" 0)"
  set_vars vm_filename vm_path git_tag "${vm_details}"
  assert_vm_filename "${vm_filename}" "squeak.cog.v3_win64x64_"
  assertEquals "${config_vm_dir}/SqueakConsole.exe" "${vm_path}"
  starts_with "${git_tag}" "v2" || fail "Unexpected git_tag: '${git_tag}'"

  set +e
  $(filename="$(squeak::get_vm_details "Squeak64-trunk" "Linux" 2>/dev/null)") \
      || fail "Should be successful."
  $(filename="$(squeak::get_vm_details "" 2>/dev/null)") \
      && fail "Should not be successful."
  $(filename="$(squeak::get_vm_details "Windows" 2>/dev/null)") \
      && fail "Should not be successful."
  set -e
}

source "${BASE}/lib/shunit2"
