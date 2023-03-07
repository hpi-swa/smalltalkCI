helpers
promptToProceedImpl

	| result |
	"First, close any remaining progress bars, that are caused by reading the setup script"
	SystemProgressMorph reset.	

	result := (self
		chooseOptionFrom: #('Proceed' 'Inspect image')
		title: 'smalltalkCI has finished loading the project. The image is now ready for testing.
If you choose to inspect the image, you must save and quit the image to proceed.').
	"Depending on the version of Squeak, valueSupplyingAnswer might return either the
	value or the label, and in all versions, nil might be returned if the user cancels the operation."
	^ result = 1 or: [result = 'Proceed']