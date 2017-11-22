compatibility
linesOf: aFilePath
	| fs loc |
	fs := StandardFileStream fileNamed: aFilePath.
	loc := fs contentsOfEntireFile lineCount.
	fs close.
	^ loc