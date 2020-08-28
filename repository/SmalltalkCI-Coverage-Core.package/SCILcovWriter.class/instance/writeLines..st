exporting
writeLines: lineHits

	| hitCount instrumented |
	lineHits withIndexDo: [:hitcount :index |
		hitcount ifNotNil: [self stream nextPutAll: 'DA:', index asString, ',', hitcount asString, self lineEnding]].
	instrumented := lineHits select: #notNil.
	hitCount := (instrumented select: [:hitcount | hitcount > 0]) size.
	self stream 
		nextPutAll: 'LH:', hitCount asString, self lineEnding;
		nextPutAll: 'LF:', instrumented size asString, self lineEnding.