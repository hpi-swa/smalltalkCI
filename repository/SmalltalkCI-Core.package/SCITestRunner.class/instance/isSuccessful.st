accessing
isSuccessful
	^ self totalTests > 0 and: [(self erroredTests + self failedTests) = 0]