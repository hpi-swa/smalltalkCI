instance creation
newTravisID
	"Random and image-specific identifier for Travis folds"
	| r |
	r := Random new.
	^ (ByteArray with: (r nextInteger: 255) with: (r nextInteger: 255)) hex
