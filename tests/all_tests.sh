#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${BASE}/run_tests.sh"
"${BASE}/helpers_tests.sh"
"${BASE}/pharo_tests.sh"
"${BASE}/squeak_tests.sh"
