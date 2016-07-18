executing
test
	| successful |
	self prepareForTesting.
	self isCoverageTestingEnabled
		ifTrue: [
			successful := self runTestsWithCoverage.
			SmalltalkCI printToStdout: 'Testing stage (including coverage) completed'. ]
		ifFalse: [
			successful := self runTests.
			SmalltalkCI printToStdout: 'Testing stage completed'. ].
	successful
		ifTrue: [ SmalltalkCI platformClass closeImageWithExitCode: 0 ]
		ifFalse: [
			SmalltalkCI platformClass saveImage.
			SmalltalkCI platformClass closeImageWithExitCode: 1 ]
	