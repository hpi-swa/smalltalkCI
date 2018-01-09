compatibility
coverallsBuildData
	| reference |
	reference := self coverallsBuildDataFilename asFileReference.
	[ ^ (reference readStreamDo: [ :stream | STON fromStream: stream ]) ]
		on: STONReaderError do: [ :error |
			error messageText: 'Cannot read ', self coverallsDataFilename, '.'.
			error signal ]