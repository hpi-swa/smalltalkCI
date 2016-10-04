executing
test
	| time runner message |
	SmalltalkCI startTravisFold: 'test_project' title: 'Testing project...'.
	
	self prepareForTesting.
	time := SmalltalkCI timeToRun: [
		self isCoverageTestingEnabled
			ifTrue: [
				runner := self runTestsWithCoverage.
				message := 'Testing stage (including coverage) completed' ]
			ifFalse: [
				runner := self runTests.
				message := 'Testing stage completed' ] ].
	
	SmalltalkCI endTravisFold: 'test_project' message: message time: time.
	
	self reportResults: runner.
	
	SmalltalkCI platformClass isHeadless ifFalse: [ self halt ].
	
	runner isSuccessful
		ifTrue: [ SmalltalkCI platformClass closeImageWithExitCode: 0 ]
		ifFalse: [
			self printStepsToReproduceLocally.
			SmalltalkCI platformClass saveImage.
			SmalltalkCI platformClass closeImageWithExitCode: 1 ]
	