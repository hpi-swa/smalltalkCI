compatibility
coverallsBuildData
	| stream data |
	stream := StandardFileStream oldFileNamed: self coverallsBuildDataFilename.
  	stream := MultiByteFileStream newFrom: stream.
	[ data := STON fromStream: stream ]
		on: STONReaderError do: [ :error |
			SmalltalkCI printToStdout: 'Cannot read ', self coverallsDataFilename, ':', Character cr, error asString.
			SmalltalkCI saveAndQuitImage ].
	stream close.
	^ data