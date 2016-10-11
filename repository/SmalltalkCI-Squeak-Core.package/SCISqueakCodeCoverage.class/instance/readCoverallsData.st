helpers
readCoverallsData
	| stream data |
	stream := StandardFileStream oldFileNamed: self class coverallsDataFilename.
  	stream := MultiByteFileStream newFrom: stream.
	[ data := STON fromStream: stream ]
		on: STONReaderError do: [ :error |
			SmalltalkCI printToStdout: 'Cannot read ', self class coverallsDataFilename, ':', Character cr, error asString.
			SmalltalkCI saveAndQuitImage ].
	stream close.
	^ data