#!/bin/bash

print_info() {
  printf "\e[0;34m%s\e[0m\n" "$1"
}

print_notice() {
  printf "\e[1;33m%s\e[0m\n" "$1"
}

print_success() {
  printf "\e[1;32m%s\e[0m\n" "$1"
}

print_error() {
  printf "\e[1;31m%s\e[0m\n" "$1" 1>&2
}

print_error_and_exit() {
  print_error "$1"
  exit 1
}

print_debug() {
  printf "\e[0;37m%s\e[0m\n" "$1"
}

print_timed() {
  LAST_PRINT=$(date +%s)
  print_info "$1"
}

print_timed_result() {
  if [[ -n "${LAST_PRINT}" ]]; then
    diff=$(($(date +%s) - LAST_PRINT))
    print_info "[$1: ${diff}s]"
  fi
}

print_help() {
  cat <<EOF
  USAGE: run.sh [options] /path/to/project

  This program prepares Smalltalk images/vms, loads projects and runs tests.

  OPTIONS:
    --baseline              Overwrite baseline.
    --baseline-group        Overwrite baseline group.
    --builder-ci            Use builderCI (default 'false').
    -d | --debug            Enable debug mode.
    --directory             Overwrite directory.
    --excluded-categories   Overwrite categories to be excluded (Squeak only).
    --excluded-classes      Overwrite classes to be excluded (Squeak only).
    --force-update          Force an update in Squeak image (default 'false').
    -h | --help             Show this help text.
    -o | --keep-open        Keep image open and do not close on error.
    --script                Overwrite custom script to run (Squeak only).
    -s | --smalltalk        Overwrite Smalltalk image selection.
    -v | --verbose          Enable 'set -x'.

  EXAMPLE: run.sh -s "Squeak-trunk" --directory "subdir" /path/to/project

EOF
}

print_junit_xml() {
  local path=$1

  printf "\n\n"
  print_info "#### JUnit XML Output Start ####"
  cat "${path}/"*.xml
  printf "\n"
  print_info "#### JUnit XML Output End ####"
  printf "\n\n"
}

is_empty() {
  local var=$1

  [[ -z $var ]]
}

is_not_empty() {
  local var=$1

  [[ -n $var ]]
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

is_dir() {
  local dir=$1

  [[ -d $dir ]]
}

program_exists() {
  local program=$1

  [[ $(which "${program}" 2> /dev/null) ]]
}

is_travis_build() {
  [[ "${TRAVIS}" = "true" ]]
}

is_spur_image() {
  local image_path=$1
  local image_format_number
  # "[...] bit 5 of the format number identifies an image that requires Spur
  # support from the VM [...]"
  # http://forum.world.st/VM-Maker-ImageFormat-dtl-17-mcz-td4713569.html
  local spur_bit=5

  if is_empty "${image_path}"; then
    print_error "Image not found at '${image_path}'."
    return 0
  fi

  image_format_number="$(hexdump -n 4 -e '2/4 "%04d " "\n"' "${image_path}")"
  [[ $((image_format_number>>(spur_bit-1) & 1)) -eq 1 ]]
}

debug_enabled() {
  [[ "${config_debug}" = "true" ]]
}

download_file() {
  local url=$1

  if is_empty "${url}"; then
    print_error "download_file() expects an URL."
    exit 1
  fi

  if program_exists "curl"; then
    curl -s "${url}"
  elif program_exists "wget"; then
    wget -q -O - "${url}"
  else
    print_error "Please install curl or wget."
    exit 1
  fi
}

return_vars() {
  (IFS='|'; echo "$*")
}

set_vars() {
  local variables=(${@:1:(($# - 1))})
  local values="${!#}"

  IFS='|' read -r "${variables[@]}" <<< "${values}"
}
