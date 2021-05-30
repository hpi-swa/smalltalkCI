folding
newTravisID
	"Random and image-specific identifier for Travis folds"
	| array |
	array := ByteArray new: 2.
	Random new
		nextBytes: 2
		into: array
		startingAt: 1.
	^ array hex