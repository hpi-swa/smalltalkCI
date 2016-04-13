coverage
linesOfFile: aString 
	| fr loc |
	fr := (self projectDirectory, '/', aString) asFileReference readStream.
	loc := fr contents lineCount.
	fr close.
	^ loc