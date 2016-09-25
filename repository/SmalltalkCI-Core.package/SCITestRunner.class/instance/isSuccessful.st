helpers
isSuccessful
	^ (self erroredTests + self failedTests) = 0