testing
testNewTravisID
	| travisID |
	travisID := SmalltalkCI platformClass newTravisID.
	self assert: travisID ~= SmalltalkCI platformClass newTravisID.
	self assert: 4 equals: travisID size
