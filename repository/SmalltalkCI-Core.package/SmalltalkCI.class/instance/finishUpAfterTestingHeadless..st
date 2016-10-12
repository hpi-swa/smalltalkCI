executing
finishUpAfterTestingHeadless: buildSuccessful
	buildSuccessful
		ifTrue: [ SmalltalkCI quitImage ]
		ifFalse: [
			self printStepsToReproduceLocally.
			SmalltalkCI saveAndQuitImage ]