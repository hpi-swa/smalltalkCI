helpers
failAndQuit: aString
	"Prints and persists an internal failure for debugging purposes"
	| message |
	<haltOrBreakpointForTesting> "Skip method in Pharo linter"
	
	message := aString, String cr, String cr, 'To inspect this error, open the image in the "', self platformClass imagePath, '" directory.'.
	self
		printErrorToStdout: message;
		saveAndQuitImage;
		halt