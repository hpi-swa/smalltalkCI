private
readSTONSpec: aFilename
	| reference |
	reference := aFilename asFileReference.
	projectDirectory := reference parent fullName.
	self spec: (reference readStreamDo: [ :stream | 
		(Smalltalk at: #SmalltalkCISpec) fromStream: stream ])