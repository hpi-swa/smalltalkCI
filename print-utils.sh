#!/usr/bin/env bash

readonly ANSI_BOLD="\\033[1m"
readonly ANSI_RED="\\033[31m"
readonly ANSI_GREEN="\\033[32m"
readonly ANSI_YELLOW="\\033[33m"
readonly ANSI_BLUE="\\033[34m"
readonly ANSI_RESET="\\033[0m"

# Do not output colors if not running under a TTY (eg, piped or a non interactive shell)

print_info() {
  if [ -t 1 ]; then
    printf "${ANSI_BOLD}${ANSI_BLUE}%s${ANSI_RESET}\\n" "$1"
  else
    echo "$1"
  fi
}

print_notice() {
  if [ -t 1 ]; then
    printf "${ANSI_BOLD}${ANSI_YELLOW}%s${ANSI_RESET}\\n" "$1"
  else
    echo "$1"
  fi
}

print_success() {
  if [ -t 1 ]; then
    printf "${ANSI_BOLD}${ANSI_GREEN}%s${ANSI_RESET}\\n" "$1"
  else
    echo "$1"
  fi
}

print_error() {
  if [ -t 1 ]; then
    printf "${ANSI_BOLD}${ANSI_RED}%s${ANSI_RESET}\\n" "$1" 1>&2
  else
    echo "$1" 1>&2
  fi
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

is_nonzero() {
  local status=$1

  [[ "${status}" -ne 0 ]]
}
