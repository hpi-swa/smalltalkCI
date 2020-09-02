exporting
exportCoverallsData: coverallsData

	SmalltalkCI assureDirectoryExistence: (SmalltalkCI dirname: self lcovResultFilename).
	SmalltalkCI 
		forceNewFileNamed: self lcovResultFilename
		do: [ :stream |
			self 
				stream: stream;
				writeLineDataByFiles: coverallsData].