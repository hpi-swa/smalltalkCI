#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"


test_set_rtprio() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    return
  fi
  gcc -o "set_rtprio_limit" "${BASE}/utils/set_rtprio_limit.c"
  if [[ ! -f "set_rtprio_limit" ]]; then
    fail "set_rtprio_limit should exist"
  fi
}

source "${BASE}/lib/shunit2"
