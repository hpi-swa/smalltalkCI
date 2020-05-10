#!/usr/bin/env bash

source "../print-utils.sh"

readonly COVERALLS_API="https://coveralls.io/api/v1/jobs"
readonly coverage_results="${SMALLTALK_CI_BUILD}/coveralls_results.json"
upload_status=0

if is_file "${coverage_results}"; then
  print_info "Uploading coverage results to Coveralls..."
  curl -s -F json_file="@${coverage_results}" "${COVERALLS_API}" > /dev/null || upload_status=$?
  if is_nonzero "${upload_status}"; then
    print_error "Failed to upload coverage results (curl error code #${upload_status})"
  else
    print_success "Successfully uploaded results to Coveralls."
  fi
else
  print_info "No coverage result file was found. Skipping upload."
fi
