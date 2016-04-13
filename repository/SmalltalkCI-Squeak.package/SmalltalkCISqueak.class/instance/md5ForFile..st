private
md5ForFile: aString
	| fs md5 |
	fs := StandardFileStream fileNamed: self projectDirectory, FileDirectory slash, aString.
	md5 := WebUtils md5Digest: fs contentsOfEntireFile.
	fs close.
	^ md5