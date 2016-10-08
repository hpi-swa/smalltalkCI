helpers
print: aString
	stream nextPutAll: ((Smalltalk at: #UTF8Encoding) encode: aString)