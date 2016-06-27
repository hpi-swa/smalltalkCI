coverage
linesForFile: aFile
	| fs loc |
	fs := StandardFileStream fileNamed: aFile.
	loc := fs contentsOfEntireFile lineCount.
	fs close.
	^ loc