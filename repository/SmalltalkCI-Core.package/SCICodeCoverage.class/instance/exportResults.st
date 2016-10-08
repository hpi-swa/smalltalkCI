helpers
exportResults
	| stream |
	stream := SmalltalkCI forceNewFileNamed: self class coverallsResultFilename.
	STON put: coverallsData asJsonOnStream: stream.
	stream close