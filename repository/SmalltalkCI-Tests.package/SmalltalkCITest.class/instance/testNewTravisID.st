testing
testNewTravisID
	| travisID |
	travisID := SmalltalkCI newTravisID.
	self assert: travisID ~= SmalltalkCI newTravisID.
	self assert: 4 equals: travisID size
