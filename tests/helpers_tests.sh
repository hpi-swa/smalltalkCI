#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"

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
  if is_file "${BASE}/foo.txt"; then
    fail "foo.txt should not be a file."
  fi
  if ! is_file "${BASE}/run.sh"; then
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
  if program_exists "foobar"; then
    fail "Program foo should exist."
  fi
  if ! program_exists "curl"; then
    fail "Programm curl should exist."
  fi
}

test_is_travis_build() {
  local TRAVIS=true
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

test_is_spur_image() {
  local spur_file="${BASE}/tests/spur.image"
  local non_spur_file="${BASE}/tests/non_spur.image"

  echo -n -e '\x79\x19\x00\x00' > "${spur_file}"
  if ! is_spur_image "${spur_file}"; then
    fail "Should be Spur."
  fi

  echo -n -e '\x69\x19\x00\x00' > "${non_spur_file}"
  if is_spur_image "${non_spur_file}"; then
    fail "Should not be Spur."
  fi

  rm "${spur_file}" "${non_spur_file}"
}

test_return_vars() {
  local value

  value="$(return_vars "")"
  assertEquals "" "${value}"

  value="$(return_vars "foo" "bar" "wiz")"
  assertEquals "foo|bar|wiz" "${value}"

  value="$(return_vars "foo" "" "bar")"
  assertEquals "foo||bar" "${value}"
}

test_set_vars() {
  local a
  local b
  local c
  local d

  set_vars a b c d "x1|x2|x3|x4"

  assertEquals "x1" "${a}"
  assertEquals "x2" "${b}"
  assertEquals "x3" "${c}"
  assertEquals "x4" "${d}"

  set_vars a b c d "x|y"

  assertEquals "x" "${a}"
  assertEquals "y" "${b}"
  assertEquals "" "${c}"
  assertEquals "" "${d}"

  set_vars a b c d "||1|2"

  assertEquals "" "${a}"
  assertEquals "" "${b}"
  assertEquals "1" "${c}"
  assertEquals "2" "${d}"
}

source "${BASE}/lib/shunit2"
