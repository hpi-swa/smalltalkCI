private
readSTONSpec: aFilename
	| reference |
	reference := aFilename asFileReference.
	reference readStreamDo: [ :stream | 
		self spec: (SmalltalkCISpec fromStream: stream) ]