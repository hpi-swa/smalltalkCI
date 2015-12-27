#! /bin/sh

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/run.sh"

test_determine_project_home() {
  local project_home

  PROJECT_HOME="/tmp"
  determine_project_home "/foo"
  assertEquals "/tmp" "${project_home}"
  unset PROJECT_HOME
  
  determine_project_home "/tmp"
  assertEquals "/tmp" "${project_home}"

  determine_project_home "../"
  assertNotNull "${project_home}"
  assertEquals "/" "${project_home:0:1}"
}

test_check_env_vars_options() {
  local baseline_group=""
  local packages
  local force_update
  local builder_ci_fallback
  local run_script
  local excluded_categories
  local excluded_classes
  local keep_open

  BASELINE_GROUP="foo1"
  PACKAGES="foo2"
  FORCE_UPDATE="false"
  BUILDERCI="true"
  RUN_SCRIPT="foo.st"
  EXCLUDE_CATEGORIES="foo3"
  EXCLUDE_CLASSES="foo4"
  KEEP_OPEN="true"

  check_env_vars_options

  assertEquals "foo1" "${baseline_group}"
  assertEquals "foo2" "${packages}"
  assertEquals "false" "${force_update}"
  assertEquals "true" "${builder_ci_fallback}"
  assertEquals "foo.st" "${run_script}"
  assertEquals "foo3" "${excluded_categories}"
  assertEquals "foo4" "${excluded_classes}"
  assertEquals "true" "${keep_open}"
}

test_prepare_folders() {
  project_home="/tmp"
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
