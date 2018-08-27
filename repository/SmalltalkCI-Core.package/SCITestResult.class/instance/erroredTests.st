accessing
erroredTests
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + (clsResults select: [ :r | r errored ]) size ].
	^ size