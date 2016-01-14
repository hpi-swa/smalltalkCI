#!/bin/bash

print_info() {
  printf "\e[1;34m%s\e[0m\n" "$1"
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

print_timed() {
  reset_timer
  print_info "$1"
}

reset_timer() {
  LAST_PRINT=$(date +%s)
}

print_timed_result() {
  local title=$1
  local time_diff

  if [[ -n "${LAST_PRINT}" ]]; then
    time_diff=$(($(date +%s) - LAST_PRINT))
    printf "\e[0;33m%s: %ss\e[0m\n" "${title}" "${time_diff}"
  fi
}

travis_fold() {
  local action=$1
  local name=$2
  local title=$3

  if is_travis_build; then
    echo -en "travis_fold:${action}:${name}\r\033[0K"
  fi
  if is_not_empty "${title}"; then
    echo -e "\033[34;1m${title}\033[0m"
  fi
}

print_help() {
  cat <<EOF
  USAGE: run.sh [options] /path/to/project

  This program prepares Smalltalk images/vms, loads projects and runs tests.

  OPTIONS:
    --builder-ci            Use builderCI (default 'false').
    --clean                 Clear cache and delete builds.
    -d | --debug            Enable debug mode.
    -h | --help             Show this help text.
    --headful               Open vm in headful mode.
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
