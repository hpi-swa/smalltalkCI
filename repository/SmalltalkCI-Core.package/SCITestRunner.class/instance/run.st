running
run
	[ self setUp. suiteTime := [ self runAll ] timeToRun ] ensure: [ self tearDown ]