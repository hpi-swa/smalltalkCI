helpers
promptToProceedImpl
	| query |
	query := 'smalltalkCI has finished loading the project. The image is now ready for testing.
If you choose to inspect the image, you must save and quit the image to proceed.'.
	
	(ProvideAnswerNotification signal: query) ifNotNil: [ :answer |
		^ answer ].
	
	^ UIManager default
	      confirm: query
			trueChoice: 'Proceed'
			falseChoice: 'Inspect image'
