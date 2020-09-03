testing
testPromptToProceedClosesProgress

	'Test progress' displayProgressFrom: 1 to: 3 during: [:bar |
		self assert: (self currentWorld findA: SystemProgressMorph) notNil.
		[SmalltalkCI promptToProceed]
			on: ProvideAnswerNotification
			do: [:notification | 
				self assert: (self currentWorld findA: SystemProgressMorph) isNil.
				notification resume: true]]