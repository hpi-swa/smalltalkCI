private
isInTonelFormat: projectDirectory
	^ spec loading
		anySatisfy: [ :loadspec | 
			self class
				isInTonelFormatCodeLocatedAt: projectDirectory , SmalltalkCI pathNameDelimiter , loadspec directory ]