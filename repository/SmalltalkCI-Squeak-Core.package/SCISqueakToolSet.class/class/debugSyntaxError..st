debugging
debugSyntaxError: anError
	| s |
	s := FileStream stderr.
	s nextPutAll: '----- Syntax error -----'; cr.
	s nextPutAll: anError errorCode; cr.
	s nextPutAll: '----- Syntax error -----'; cr.

	self debugError: anError