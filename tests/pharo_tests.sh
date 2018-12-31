#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"
source "${BASE}/pharo/run.sh"

test_get_image_url() {
  local image_url

  image_url="$(pharo::get_image_url "Pharo32-alpha")"
  assertEquals "get.pharo.org/alpha" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-stable")"
  assertEquals "get.pharo.org/stable" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-6.0")"
  assertEquals "get.pharo.org/60" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-5.0")"
  assertEquals "get.pharo.org/50" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-4.0")"
  assertEquals "get.pharo.org/40" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-3.0")"
  assertEquals "get.pharo.org/30" "${image_url}"

  set +e
  $(image_url="$(pharo::get_image_url "Pharo32-alpha" 2>/dev/null)") \
      || fail "Should be successful."
  $(image_url="$(pharo::get_image_url "" 2>/dev/null)") \
      && fail "Should not be successful."
  $(image_url="$(pharo::get_image_url "Squeak" 2>/dev/null)") \
      && fail "Should not be successful."
  set -e
}

test_get_vm_url() {
  local vm_url

  vm_url="$(pharo::get_vm_url "Pharo32-alpha")"
  assertEquals "get.pharo.org/vmLatest70" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-stable")"
  assertEquals "get.pharo.org/vm61" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-7.0")"
  assertEquals "get.pharo.org/vm70" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-6.0")"
  assertEquals "get.pharo.org/vm60" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-5.0")"
  assertEquals "get.pharo.org/vm50" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-4.0")"
  assertEquals "get.pharo.org/vm40" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-3.0")"
  assertEquals "get.pharo.org/vm30" "${vm_url}"

  set +e
  $(vm_url="$(pharo::get_vm_url "Pharo32-alpha" 2>/dev/null)") \
      || fail "Should be successful."
  $(vm_url="$(pharo::get_vm_url "" 2>/dev/null)") \
      && fail "Should not be successful."
  $(vm_url="$(pharo::get_vm_url "Squeak" 2>/dev/null)") \
      && fail "Should not be successful."
  set -e
}

source "${BASE}/lib/shunit2"
