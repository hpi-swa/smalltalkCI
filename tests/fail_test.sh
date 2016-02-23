#!/bin/bash

if [[ "${TRAVIS}" != "true" ]]; then
	echo "This test needs to run on Travis."
	exit 1
fi

exit_status=0
$SMALLTALK_CI_HOME/run.sh --debug $SMALLTALK_CI_HOME/.smalltalk_fail.ston || exit_status=$?
if [[ "${exit_status}" -eq 0 ]]; then
	echo "smalltalkCI passed unexpectedly."
  exit 1
fi
