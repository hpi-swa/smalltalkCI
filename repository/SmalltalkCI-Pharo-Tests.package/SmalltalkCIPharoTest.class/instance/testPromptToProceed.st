testing
testPromptToProceed
	"When testing on old versions of Pharo, a Non-interactive UIManager might be installed in headless mode,
	which will behave differently from the MorphicUIManager i.e. it doesn't allow interactive 
	requests like confirm: . As promptToProceed only really makes sense in an interactive context,
	always test with the MorphicUIManager"
	|oldUIManager|

	"Skip this test on GToolkit"
	(Smalltalk hasClassNamed: 'GtImageSetup') ifTrue: [ ^ self ].

	oldUIManager := UIManager default.
	UIManager default: MorphicUIManager new.
	
	[self should: [SmalltalkCI promptToProceed] raise: ProvideAnswerNotification.
	self assert: ([SmalltalkCI promptToProceed] valueSupplyingAnswer: true).
	self deny: ([SmalltalkCI promptToProceed] valueSupplyingAnswer: false)]
		ensure: [UIManager default: oldUIManager]