private
readSTONSpec: aFilename
	| reference |
	reference := aFilename asFileReference.
	projectDirectory := reference parent fullName.
	reference readStreamDo: [ :stream | 
		self spec: (SmalltalkCISpec fromStream: stream) ]