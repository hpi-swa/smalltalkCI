fixtures
failureFixture
	^ SmalltalkCI isTravisBuild
		ifTrue: [ self failureFixtureTravis ]
		ifFalse: [ self failureFixtureNonTravis ]