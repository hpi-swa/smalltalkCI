coverage
linesForFile: aFilename 
	| fs loc |
	fs := StandardFileStream fileNamed: self projectDirectory, FileDirectory slash, aFilename.
	loc := fs contentsOfEntireFile lineCount.
	fs close.
	^ loc