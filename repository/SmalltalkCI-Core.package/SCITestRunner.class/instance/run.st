running
run
	[ self setUp. suiteTime := SmalltalkCI platformClass timeToRun: [ self runAll ] ] ensure: [ self tearDown ]