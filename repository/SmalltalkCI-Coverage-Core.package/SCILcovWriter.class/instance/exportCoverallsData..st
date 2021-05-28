exporting
exportCoverallsData: coverallsData

	SmalltalkCI assureDirectoryExistence: (SmalltalkCI dirname: self lcovResultFilename).
	SmalltalkCI 
		forceNewFileNamed: self lcovResultFilename
		do: [ :aStream |
			self 
				stream: aStream;
				writeLineDataByFiles: coverallsData].