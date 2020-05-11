#!/usr/bin/env bash

source "../print-utils.sh"

upload_status=0
coverage_results="${SMALLTALK_CI_BUILD}/coveralls_results.json"

if is_file "${coverage_results}"; then
  print_info "Uploading coverage results to CodeCov..."
  bash <(curl -s https://codecov.io/bash) -f ${coverage_results} || upload_status=$?
  if is_nonzero "${upload_status}"; then
    print_error "Failed to upload coverage results."
  else
    print_success "Successfully uploaded results to CodeCov."
  fi
else
  print_info "No coverage result file was found. Skipping upload."
fi
