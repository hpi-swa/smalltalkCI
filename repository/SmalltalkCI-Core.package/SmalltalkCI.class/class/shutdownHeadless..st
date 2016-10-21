finalizing
shutdownHeadless: buildSuccessful
	buildSuccessful
		ifTrue: [ self quitImage ]
		ifFalse: [
			self printStepsToReproduceLocally.
			self saveAndQuitImage ]