coverage
md5ForFile: aFilename 
	| fr loc |
	fr := (self projectDirectory, '/', aFilename) asFileReference readStream.
	loc := (MD5 hashMessage: fr contents) hex.
	fr close.
	^ loc