coveralls
directoryFor: methodReference in: projectDirectory
	^ (spec loading
		collect: [ :loadspec | projectDirectory, SmalltalkCI pathNameDelimiter, loadspec directory ])
		detect: [ :dir | SmalltalkCI fileExists: (self class filePathFor: methodReference in: dir) ]
		ifNone: []