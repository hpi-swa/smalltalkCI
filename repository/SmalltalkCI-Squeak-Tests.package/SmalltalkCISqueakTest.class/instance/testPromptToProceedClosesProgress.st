testing
testPromptToProceedClosesProgress

	"Make sure we have a progress bar open"
	SystemProgressMorph position: 0@0 label: 'test progress' min: 0 max: 3.

	self assert: (self currentWorld findA: SystemProgressMorph) notNil.
	[SmalltalkCI promptToProceed]
		on: ProvideAnswerNotification
		do: [:notification | 
			self assert: (self currentWorld findA: SystemProgressMorph) isNil.
			notification resume: 1]