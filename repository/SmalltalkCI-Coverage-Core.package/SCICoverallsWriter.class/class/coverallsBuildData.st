coveralls
coverallsBuildData

	SmalltalkCI readOnlyFileNamed: self coverallsBuildDataFilename
		do: [ :stream | 
			[^ STON fromStream: stream] 
				on: STONReaderError
				do: [:error | SmalltalkCI failAndQuit: 'Cannot read ', self coverallsBuildDataFilename, ':', Character cr, error asString. ]]