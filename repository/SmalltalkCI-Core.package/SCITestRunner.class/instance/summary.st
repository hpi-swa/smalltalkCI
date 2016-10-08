accessing
summary
	^ self totalTests asString, ' Tests with ', self failedTests asString, ' Failures and ', self erroredTests asString, ' Errors in ', self suiteTimeString