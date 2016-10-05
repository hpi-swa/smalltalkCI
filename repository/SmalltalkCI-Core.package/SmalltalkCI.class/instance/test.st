executing
test
	| runner |
	self headfullBreakpoint.

	SmalltalkCI travisFold: 'test_project' title: 'Testing project...' block: [
		self prepareForTesting.
		self isCoverageTestingEnabled
			ifTrue: [ runner := self runTestsWithCoverage ]
			ifFalse: [ runner := self runTests ] ].
	
	self reportResults: runner.
	
	runner isSuccessful
		ifTrue: [ self quitImage ]
		ifFalse: [
			self printStepsToReproduceLocally.
			self saveImageAndFail ]