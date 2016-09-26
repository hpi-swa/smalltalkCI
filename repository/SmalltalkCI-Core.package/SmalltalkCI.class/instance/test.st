executing
test
	| time successful message |
	SmalltalkCI startTravisFold: 'test_project' title: 'Testing project...'.
	
	self prepareForTesting.
	time := [ self isCoverageTestingEnabled
		ifTrue: [
			successful := self runTestsWithCoverage.
			message := 'Testing stage (including coverage) completed' ]
		ifFalse: [
			successful := self runTests.
			message := 'Testing stage completed' ] ] timeToRun.
	
	SmalltalkCI endTravisFold: 'test_project' message: message time: time.
	
	successful
		ifTrue: [ SmalltalkCI platformClass closeImageWithExitCode: 0 ]
		ifFalse: [
			self printStepsToReproduceLocally.
			SmalltalkCI platformClass saveImage.
			SmalltalkCI platformClass closeImageWithExitCode: 1 ]
	