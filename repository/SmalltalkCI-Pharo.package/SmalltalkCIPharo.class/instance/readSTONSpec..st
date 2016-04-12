private
readSTONSpec: aFilename
	| reference |
	reference := aFilename asFileReference.
	projectDirectory := reference parent fullName.
	[ self spec: (reference readStreamDo: [ :stream | 
		(Smalltalk at: #SmalltalkCISpec) fromStream: stream ]) ]
		on: STONReaderError do: [ :error |
			error messageText: 'Cannot read STON config file for smalltalkCI.'.
			error signal ]
