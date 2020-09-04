helpers
promptToProceedImpl

	^ UIManager default
	      confirm:  'smalltalkCI has finished loading the project. The image is now ready for testing.
If you choose to inspect the image, you must save and quit the image to proceed.'
			trueChoice: 'Proceed'
			falseChoice: 'Inspect image'
