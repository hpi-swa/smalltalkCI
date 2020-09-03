testing
testPromptToProceedClosesProgress

	"Make sure we have a progress bar open"
	SystemProgressMorph uniqueInstance openInWorld.
	self assert: (self currentWorld findA: SystemProgressMorph) notNil.
	[SmalltalkCI promptToProceed]
		on: ProvideAnswerNotification
		do: [:notification | 
			self assert: (self currentWorld findA: SystemProgressMorph) isNil.
			notification resume: true]