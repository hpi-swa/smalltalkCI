private
tonelSourceDirectoryFor: projectDirectory
	^ spec loading
		detect:
			[ :loadspec | SmalltalkCI fileExists: projectDirectory , SmalltalkCI pathNameDelimiter , loadspec directory ]
		ifFound: [ :loadspec | projectDirectory , SmalltalkCI pathNameDelimiter , loadspec directory ]
		ifNone: [ NotFound signal ]