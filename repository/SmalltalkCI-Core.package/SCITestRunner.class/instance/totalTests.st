accessing
totalTests
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + clsResults size ].
	^ size
