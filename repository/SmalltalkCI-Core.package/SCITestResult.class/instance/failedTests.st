accessing
failedTests
	| size |
	size := 0.
	results valuesDo: [ :clsResults |
		size := size + (clsResults select: [ :r | r failed ]) size ].
	^ size