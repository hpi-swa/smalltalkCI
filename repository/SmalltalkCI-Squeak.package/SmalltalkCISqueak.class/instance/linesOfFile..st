private
linesOfFile: aString 
	| fs loc |
	fs := StandardFileStream fileNamed: self projectDirectory, FileDirectory slash, aString.
	loc := fs contentsOfEntireFile lineCount.
	fs close.
	^ loc