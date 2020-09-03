helpers
promptToProceed

	"First, close any remaining progress bars, that are caused by reading the setup script"
	SystemProgressMorph reset.
	
	"The = true check here is necessary, as Squeak provides a 'cancel' button for some reason that returns nil."
	^ (UIManager default
	      confirm:  'smalltalkCI has finished loading the project. The image is now ready for testing.
If you choose to inspect the image, you must save and quit the image to proceed.'
			trueChoice: 'Proceed'
			falseChoice: 'Inspect image') = true