coverage
md5ForFile: aFilename
	| fs md5 |
	fs := StandardFileStream fileNamed: self projectDirectory, FileDirectory slash, aFilename.
	md5 := WebUtils md5Digest: fs contentsOfEntireFile.
	fs close.
	^ md5