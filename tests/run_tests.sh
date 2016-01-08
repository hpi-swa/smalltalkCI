#! /bin/sh

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/run.sh"

test_determine_project_home() {
  local config_project_home

  if [[ -z "${PROJECT_HOME}" ]]; then
    determine_project_home "/tmp"
    assertEquals "/tmp" "${config_project_home}"

    determine_project_home "../"
    assertNotNull "${config_project_home}"
    assertEquals "/" "${config_project_home:0:1}"

    TRAVIS="true"
    TRAVIS_BUILD_DIR="/usr"
    determine_project_home "/tmp"
    assertEquals "/tmp" "${config_project_home}"
    unset TRAVIS_BUILD_DIR
    unset TRAVIS

    TRAVIS="true"
    TRAVIS_BUILD_DIR="/tmp"
    determine_project_home
    assertEquals "${TRAVIS_BUILD_DIR}" "${config_project_home}"
    unset TRAVIS_BUILD_DIR
    unset TRAVIS
  else
    determine_project_home "/tmp"
    assertEquals "${PROJECT_HOME}" "${config_project_home}"
  fi

  return 0
}

test_load_config_from_environment() {
  local config_baseline_group=""
  local config_directory
  local config_force_update
  local config_builder_ci_fallback
  local config_run_script
  local config_excluded_categories
  local config_excluded_classes
  local config_keep_open

  BASELINE_GROUP="foo1"
  PACKAGES="foo2"
  FORCE_UPDATE="false"
  BUILDERCI="true"
  RUN_SCRIPT="foo.st"
  EXCLUDE_CATEGORIES="foo3"
  EXCLUDE_CLASSES="foo4"
  KEEP_OPEN="true"

  load_config_from_environment

  assertEquals "foo1" "${config_baseline_group}"
  assertEquals "foo2" "${config_directory}"
  assertEquals "false" "${config_force_update}"
  assertEquals "true" "${config_builder_ci_fallback}"
  assertEquals "foo.st" "${config_run_script}"
  assertEquals "foo3" "${config_excluded_categories}"
  assertEquals "foo4" "${config_excluded_classes}"
  assertEquals "true" "${config_keep_open}"
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
