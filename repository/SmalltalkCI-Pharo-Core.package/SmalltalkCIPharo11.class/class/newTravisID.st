instance creation
newTravisID
	"Random and image-specific identifier for Travis folds"
	^ (ByteArray with: 255 atRandom with: 255 atRandom) hex
