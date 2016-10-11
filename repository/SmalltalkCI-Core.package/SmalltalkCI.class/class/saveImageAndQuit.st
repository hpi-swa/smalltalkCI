image-operations
saveImageAndQuit
	self platformClass saveImage
		"Close image only if it is not resuming."
		ifFalse: [ self platformClass quitImage ]