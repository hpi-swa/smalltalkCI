#! /bin/sh

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE}/../helpers.sh"

test_is_empty() {
  if ! is_empty ""; then
    fail "Empty string should be empty"
  fi
  if ! is_empty "$Foo"; then
    fail "\$Foo should be empty"
  fi
  if is_empty "Foo"; then
    fail "Foo should not be an empty value"
  fi
}

test_is_not_empty() {
  if is_not_empty ""; then
    fail "Empty string should be empty"
  fi
  if is_not_empty "$Foo"; then
    fail "\$Foo should be empty"
  fi
  if ! is_not_empty "Foo"; then
    fail "Foo should not be an empty value"
  fi
}

test_is_file() {
  if is_file "foo.txt"; then
    fail "foo.txt should not be a file."
  fi
  if ! is_file "run.sh"; then
    fail "run.sh should be a file."
  fi
}

test_is_dir() {
  if is_dir "foo"; then
    fail "foo should not be a directory."
  fi
  if ! is_dir "../"; then
    fail "../ should be a directory."
  fi
}

test_program_exists() {
  if program_exists "foo"; then
    fail "Program foo should exist."
  fi
  if ! program_exists "curl"; then
    fail "Programm curl should exist."
  fi
}

test_is_travis_build() {
  TRAVIS=true
  if ! is_travis_build; then
    fail "Should be a Travis build."
  fi

  TRAVIS=false
  if is_travis_build; then
    fail "Should not be a Travis build."
  fi

  TRAVIS=""
  if is_travis_build; then
    fail "Should not be a Travis build."
  fi
}

source "${BASE}/../lib/shunit2"
