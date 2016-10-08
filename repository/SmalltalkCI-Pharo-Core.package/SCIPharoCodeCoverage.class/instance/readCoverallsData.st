helpers
readCoverallsData
	| reference |
	reference := self class coverallsDataFilename asFileReference.
	[ ^ (reference readStreamDo: [ :stream | STON fromStream: stream ]) ]
		on: STONReaderError do: [ :error |
			error messageText: 'Cannot read ', self class coverallsDataFilename, '.'.
			error signal ]