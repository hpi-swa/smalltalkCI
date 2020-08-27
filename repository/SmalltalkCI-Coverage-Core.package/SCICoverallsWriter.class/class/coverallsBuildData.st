coveralls
coverallsBuildData

	SmalltalkCI readOnlyFileNamed: self coverallsBuildDataFilename
		do: [ :stream | 
			[^ STON fromStream: stream] 
				on: STONReaderError
				do: [:error | 
					SmalltalkCI failAndQuit: 
						'Unable to parse Coveralls build data from ', self coverallsBuildDataFilename, ':', Character cr,
						error asString, Character cr,
						'This is a smalltalkCI internal error. If the problem persists, please open an issue at https://github.com/hpi-swa/smalltalkCI/issues/new .'. ]]