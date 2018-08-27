running
run
	[ self setUp.
	  result suiteTime: (SmalltalkCI timeToRun: [ self runAll ]) ]
		ensure: [ self tearDown ].
	^ result