accessing
isSuccessful
	^ (self erroredTests + self failedTests) = 0