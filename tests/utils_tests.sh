#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../helpers.sh
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

# shellcheck source=../lib/shunit2
source "${BASE}/lib/shunit2"
