running
run
	[ self setUp. suiteTime := SmalltalkCI timeToRun: [ self runAll ] ] ensure: [ self tearDown ]