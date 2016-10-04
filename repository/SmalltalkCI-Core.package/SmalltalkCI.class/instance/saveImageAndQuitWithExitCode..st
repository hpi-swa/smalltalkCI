helpers
saveImageAndQuitWithExitCode: anExitCode
	SmalltalkCI platformClass saveImage
		"Close image only if it is not resuming."
		ifFalse: [ SmalltalkCI platformClass closeImageWithExitCode: anExitCode ]