helpers
md5ForFile: aFilename 
	| fr loc |
	fr := aFilename asFileReference readStream.
	loc := (MD5 hashMessage: fr contents) hex.
	fr close.
	^ loc