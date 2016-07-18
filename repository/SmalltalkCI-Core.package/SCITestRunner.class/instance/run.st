running
run
	[ self setUp. suiteTime := [ self runAll ] timeToRun ] ensure: [ self tearDown ].
	^ (self erroredTests + self failedTests) = 0