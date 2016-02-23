#!/bin/bash

set -e

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"

if ! is_travis_build; then
  print_error_and_exit "This test needs to run on Travis."
fi

if is_empty "${SMALLTALK_CI_HOME}" || is_empty "${SMALLTALK_CI_BUILD_BASE}"; then
  print_error_and_exit "SMALLTALK_CI_HOME or SMALLTALK_CI_BUILD_BASE not set."
fi

if is_dir "${SMALLTALK_CI_BUILD_BASE}/travis"; then
  print_info "Removing old build folder at ${SMALLTALK_CI_BUILD_BASE}/travis"
  rm -rf "${SMALLTALK_CI_BUILD_BASE}/travis"
fi

print_info "Starting second pass to check that smalltalkCI can fail..."
exit_status=0
$SMALLTALK_CI_HOME/run.sh --debug $SMALLTALK_CI_HOME/.smalltalk_fail.ston || exit_status=$?

if [[ "${exit_status}" -eq 0 ]]; then
  print_error_and_exit "smalltalkCI passed unexpectedly."
fi
