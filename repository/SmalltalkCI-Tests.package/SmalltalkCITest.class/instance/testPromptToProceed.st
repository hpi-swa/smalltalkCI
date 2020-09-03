testing
testPromptToProceed

	self platformUsesPromptToProceed ifFalse: [^ self].
	
	self should: [SmalltalkCI promptToProceed] raise: ProvideAnswerNotification.
	self assert: ([SmalltalkCI promptToProceed] valueSupplyingAnswer: true).
	self deny: ([SmalltalkCI promptToProceed] valueSupplyingAnswer: false).