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

print_help() {
  cat <<EOF

Usage: run.sh [options] /path/to/project

--baseline              Overwrite baseline.
--baseline-group        Overwrite baseline group.
--builder-ci            Use builderCI (default 'false').
--directory             Overwrite directory.
--excluded-categories   Overwrite categories to be excluded (Squeak only).
--excluded-classes      Overwrite classes to be excluded (Squeak only).
--force-update          Force an update in Squeak image (default 'false').
-h | --help             Show this help text.
-o | --keep-open        Keep image open and do not close on error.
--script                Overwrite custom script to run (Squeak only).
-s | --smalltalk        Overwrite Smalltalk image selection.

Example: run.sh -s "Squeak-trunk" --directory "subdir" /path/to/project

EOF
}

print_timed() {
  LAST_PRINT=$(date +%s)
  print_info "$1"
}

print_timed_result() {
  if [[ -n "${LAST_PRINT}" ]]; then
    diff=$(($(date +%s) - ${LAST_PRINT}))
    print_info "[$1: ${diff}s]"
  fi
}

download_file() {
  local url=$1

  if [[ -z "${url}" ]]; then
    print_error "download_file() expects an URL."
    exit 1
  fi

  if [[ $(which curl 2> /dev/null) ]]; then
    curl -s "${url}";
  elif [[ $(which wget 2> /dev/null) ]]; then
    wget -q -O - "${url}";
  else
    print_error "Please install curl or wget.";
    exit 1
  fi
}