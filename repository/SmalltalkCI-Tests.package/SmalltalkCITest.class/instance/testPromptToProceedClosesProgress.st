testing
testPromptToProceedClosesProgress

	|progressMorph|
	self platformUsesPromptToProceed ifFalse: [^ self].
	
	"Make sure we have a progress bar open"
	progressMorph := SystemProgressMorph uniqueInstance
		openInWorld; 
		yourself.
	"Workaround for a bug in some Squeak versions. UniqueInstance isn't set when using lazy initialization"
	SystemProgressMorph classPool at: #UniqueInstance put: progressMorph.
	
	self assert: (self currentWorld findA: SystemProgressMorph) notNil.
	[SmalltalkCI promptToProceed]
		on: ProvideAnswerNotification
		do: [:notification | 
			self assert: (self currentWorld findA: SystemProgressMorph) isNil.
			notification resume: true]