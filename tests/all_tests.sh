#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

status=0

"${BASE}/run_tests.sh" || status=$?
echo "======================================================"
"${BASE}/helpers_tests.sh" || status=$?
echo "======================================================"
"${BASE}/pharo_tests.sh" || status=$?
echo "======================================================"
"${BASE}/squeak_tests.sh" || status=$?
echo "======================================================"
"${BASE}/utils_tests.sh" || status=$?
echo "======================================================"

exit "${status}"