coverage
linesForFile: aFilename 
	| fr loc |
	fr := (self projectDirectory, '/', aFilename) asFileReference readStream.
	loc := fr contents lineCount.
	fr close.
	^ loc