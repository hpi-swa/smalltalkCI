executing
finishUpAfterTestingHeadless: buildSuccessful
	buildSuccessful
		ifTrue: [ self class quitImage ]
		ifFalse: [
			self printStepsToReproduceLocally.
			self class saveAndQuitImage ]