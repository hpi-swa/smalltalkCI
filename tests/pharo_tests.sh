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

  image_url="$(pharo::get_image_url "Pharo64-alpha")"
  assertEquals "get.pharo.org/64/alpha" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-stable")"
  assertEquals "get.pharo.org/64/stable" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-12")"
  assertEquals "get.pharo.org/64/120" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-11")"
  assertEquals "get.pharo.org/64/110" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-10")"
  assertEquals "get.pharo.org/64/100" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-9.0")"
  assertEquals "get.pharo.org/64/90" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo64-8.0")"
  assertEquals "get.pharo.org/64/80" "${image_url}"


  image_url="$(pharo::get_image_url "Pharo32-12")"
  assertEquals "get.pharo.org/32/120" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-11")"
  assertEquals "get.pharo.org/32/110" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-10")"
  assertEquals "get.pharo.org/32/100" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-9.0")"
  assertEquals "get.pharo.org/32/90" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-8.0")"
  assertEquals "get.pharo.org/80" "${image_url}"

  image_url="$(pharo::get_image_url "Pharo32-7.0")"
  assertEquals "get.pharo.org/70" "${image_url}"

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
  assertEquals "get.pharo.org/vmLatest130" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-alpha")"
  assertEquals "get.pharo.org/64/vmLatest130" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-stable")"
  assertEquals "get.pharo.org/vm120" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-stable")"
  assertEquals "get.pharo.org/64/vm120" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-13")"
  assertEquals "get.pharo.org/64/vm130" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-12")"
  assertEquals "get.pharo.org/64/vm120" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-11")"
  assertEquals "get.pharo.org/64/vm110" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-10")"
  assertEquals "get.pharo.org/64/vm100" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-9.0")"
  assertEquals "get.pharo.org/64/vm90" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo64-8.0")"
  assertEquals "get.pharo.org/64/vm80" "${vm_url}"


  vm_url="$(pharo::get_vm_url "Pharo32-13")"
  assertEquals "get.pharo.org/vm130" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-12")"
  assertEquals "get.pharo.org/vm120" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-11")"
  assertEquals "get.pharo.org/vm110" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-10")"
  assertEquals "get.pharo.org/vm100" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-9.0")"
  assertEquals "get.pharo.org/vm90" "${vm_url}"

  vm_url="$(pharo::get_vm_url "Pharo32-8.0")"
  assertEquals "get.pharo.org/vm80" "${vm_url}"

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
