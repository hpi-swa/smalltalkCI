image-operations
saveImageAndQuitWithExitCode: anExitCode
	self platformClass saveImage
		"Close image only if it is not resuming."
		ifFalse: [ self platformClass closeImageWithExitCode: anExitCode ]