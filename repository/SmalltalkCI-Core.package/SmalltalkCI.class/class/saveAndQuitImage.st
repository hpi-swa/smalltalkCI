image-operations
saveAndQuitImage
	self platformClass saveImage
		"Close image only if it is not resuming."
		ifFalse: [ self platformClass quitImage ]