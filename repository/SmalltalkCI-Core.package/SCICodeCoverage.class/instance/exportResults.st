helpers
exportResults
	SmalltalkCI
		forceNewFileNamed: self class coverallsResultFilename
		do: [ :stream | STON put: coverallsData asJsonOnStream: stream ]