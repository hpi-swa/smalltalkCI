helpers
failAndQuit: aString
	"Prints and persists an internal failure for debugging purposes"
	| message |
	message := aString, Character cr, Character cr, 'To inspect this error, open the image in the "', self platformClass imagePath, '" directory'.
	self
		printErrorToStdout: message;
		saveAndQuitImage;
		halt