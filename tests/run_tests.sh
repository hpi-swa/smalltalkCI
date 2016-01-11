#! /bin/sh

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/run.sh"

test_determine_project_home() {
  local config_project_home
  local travis="${TRAVIS}"

  determine_project_home "/tmp"
  assertEquals "/tmp" "${config_project_home}"

  determine_project_home "../"
  assertEquals "/" "${config_project_home:0:1}"

  [[ -z "${travis}" ]] && export TRAVIS="true" && export TRAVIS_BUILD_DIR="/tmp"
  determine_project_home "/usr"
  assertEquals "/usr" "${config_project_home}"
  determine_project_home
  assertEquals "${TRAVIS_BUILD_DIR}" "${config_project_home}"
  [[ -z "${travis}" ]] && unset TRAVIS_BUILD_DIR && unset TRAVIS

  return 0
}

test_prepare_folders() {
  config_project_home="/tmp"
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
  if [[ -d "${SMALLTALK_CI_GIT}" ]]; then
    fail "${SMALLTALK_CI_GIT} should not exist."
  fi

  prepare_folders > "/dev/null"

  if [[ ! -d "${SMALLTALK_CI_CACHE}" ]]; then
    fail "${SMALLTALK_CI_CACHE} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_BUILD_BASE}" ]]; then
    fail "${SMALLTALK_CI_BUILD_BASE} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_VMS}" ]]; then
    fail "${SMALLTALK_CI_VMS} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_BUILD}" ]]; then
    fail "${SMALLTALK_CI_BUILD} should exist."
  fi
  if [[ ! -d "${SMALLTALK_CI_GIT}" ]]; then
    fail "${SMALLTALK_CI_GIT} should exist."
  fi

  rm -rf "${SMALLTALK_CI_CACHE}" "${SMALLTALK_CI_BUILD_BASE}"
}

source "${BASE}/lib/shunit2"
