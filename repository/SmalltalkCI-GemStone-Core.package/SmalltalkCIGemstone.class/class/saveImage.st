compatibility
saveImage
	(Smalltalk at: #System) commitTransaction.
	"It is unclear if the image is resuming, so it always returns that it is not."
	^ false