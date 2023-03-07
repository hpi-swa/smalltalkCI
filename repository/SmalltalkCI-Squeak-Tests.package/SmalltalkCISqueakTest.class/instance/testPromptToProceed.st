testing
testPromptToProceed
	
	self should: [SmalltalkCI promptToProceed] raise: ProvideAnswerNotification.
	"Depending on the Squeak version valueSupplyingAnswer: on a chooseFrom: dialog
	expects the index of the value, or the label name"
	self assert: (([SmalltalkCI promptToProceed] valueSupplyingAnswer: 1)
					or: [[SmalltalkCI promptToProceed] valueSupplyingAnswer: 'Proceed']).
	self deny: (([SmalltalkCI promptToProceed] valueSupplyingAnswer: 2)
					or: [[SmalltalkCI promptToProceed] valueSupplyingAnswer: 'Inspect image']).