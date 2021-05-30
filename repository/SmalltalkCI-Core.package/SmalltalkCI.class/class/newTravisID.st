folding
newTravisID
	"Random and image-specific identifier for Travis folds"
	| bytes random |
	bytes := ByteArray new: 2.
	random := Random new.
	1
		to: 2
		do: [ :index |
			bytes
				at: index
				put: (random nextInt: 255) ].
	^ bytes hex