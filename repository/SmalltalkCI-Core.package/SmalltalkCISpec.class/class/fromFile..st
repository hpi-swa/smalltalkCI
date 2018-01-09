instance creation
fromFile: aFilename
	SmalltalkCI readOnlyFileNamed: aFilename
		do: [ :stream | ^ self fromStream: stream]