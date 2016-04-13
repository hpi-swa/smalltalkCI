coverage
md5ForFile: aString 
	| fr loc |
	fr := (self projectDirectory, '/', aString) asFileReference readStream.
	loc := (MD5 hashMessage: fr contents) hex.
	fr close.
	^ loc