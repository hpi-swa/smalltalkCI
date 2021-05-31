folding
newTravisID
	"Random and image-specific identifier for Travis folds"
	| r |
	r := Random new.
	^ (ByteArray with: (r nextInt: 255) with: (r nextInt: 255)) hex
