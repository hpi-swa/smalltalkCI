executing
test
	| runner |
	self headfullBreakpoint.

	SmalltalkCI stage: 'Testing project...' id: 'test_project' block: [
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