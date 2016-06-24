coverage
md5ForFile: aFile
	| fs md5 |
	fs := StandardFileStream fileNamed: aFile.
	md5 := WebUtils md5Digest: fs contentsOfEntireFile.
	fs close.
	^ md5