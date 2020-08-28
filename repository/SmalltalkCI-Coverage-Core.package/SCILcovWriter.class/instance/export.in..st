exporting
export: codeCoverage in: projectDirectory

	SmalltalkCI 
		forceNewFileNamed: self class lcovResultFilename
		do: [ :stream |
			self 
				stream: stream;
				projectDirectory: projectDirectory;
				writeLineDataByFiles: (codeCoverage coverallsSourceFilesIn: self projectDirectory)].