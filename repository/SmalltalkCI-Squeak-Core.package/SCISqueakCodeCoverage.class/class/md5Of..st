compatibility
md5Of: aFilePath
	| fs md5 |
	fs := StandardFileStream fileNamed: aFilePath.
	md5 := WebUtils md5Digest: fs contentsOfEntireFile.
	fs close.
	^ md5