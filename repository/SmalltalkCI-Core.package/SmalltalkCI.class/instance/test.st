executing
test
	self prepareForTesting.
	self isCoverageTestingEnabled
		ifTrue: [
			self runTestsWithCoverage.
			SmalltalkCI printToStdout: 'Testing stage (including coverage) completed'. ]
		ifFalse: [
			self runTests.
			SmalltalkCI printToStdout: 'Testing stage completed'. ]