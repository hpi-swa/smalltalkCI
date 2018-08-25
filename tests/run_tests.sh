#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/run.sh"
# Initialize smalltalkCI
initialize

test_ensure_ston_config_exists() {
  local config_ston
  local travis="${TRAVIS:-}"

  ensure_ston_config_exists "${BASE}/.smalltalk.ston"
  assertEquals ".smalltalk.ston" "${config_ston: -15}"

  [[ -z "${travis}" ]] && export TRAVIS="true" && export TRAVIS_BUILD_DIR="${BASE}"
  ensure_ston_config_exists ""
  assertEquals ".smalltalk.ston" "${config_ston: -15}"
  [[ -z "${travis}" ]] && unset TRAVIS_BUILD_DIR && unset TRAVIS

  return 0
}

test_prepare_folders() {
  config_ston="/tmp/.smalltalk.ston"
  SMALLTALK_CI_HOME="${BASE}/tests"
  source "${BASE}/env_vars"

  if [[ -d "${SMALLTALK_CI_CACHE}" ]]; then
    fail "${SMALLTALK_CI_CACHE} should not exist."
  fi
  if [[ -d "${SMALLTALK_CI_BUILD_BASE}" ]]; then
    fail "${SMALLTALK_CI_BUILD_BASE} should not exist."
  fi
  if [[ -d "${SMALLTALK_CI_VMS}" ]]; then
    fail "${SMALLTALK_CI_VMS} should not exist."
  fi
  if [[ -d "${SMALLTALK_CI_BUILD}" ]]; then
    fail "${SMALLTALK_CI_BUILD} should not exist."
  fi

  prepare_folders > "/dev/null"

  if [[ ! -d "${SMALLTALK_CI_CACHE}" ]]; then
    fail "${SMALLTALK_CI_CACHE} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_BUILD_BASE}" ]]; then
    fail "${SMALLTALK_CI_BUILD_BASE} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_BUILD}" ]]; then
    fail "${SMALLTALK_CI_BUILD} should exist."
  fi

  rm -rf "${SMALLTALK_CI_CACHE}" "${SMALLTALK_CI_BUILD_BASE}"
}

source "${BASE}/lib/shunit2"
