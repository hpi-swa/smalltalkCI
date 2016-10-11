helpers
linesForFile: aFilename 
	| fr loc |
	fr := aFilename asFileReference readStream.
	loc := fr contents lineCount.
	fr close.
	^ loc