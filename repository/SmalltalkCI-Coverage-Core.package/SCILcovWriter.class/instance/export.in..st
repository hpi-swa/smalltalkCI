exporting
export: codeCoverage in: projectDirectory

	SmalltalkCI printToStdout: 'Writing LCOV coverage info to: ', self class lcovResultFilename ansiColor: SmalltalkCI ansiBlue.
	SmalltalkCI 
		forceNewFileNamed: self class lcovResultFilename
		do: [ :stream |
			self 
				stream: stream;
				projectDirectory: projectDirectory;
				writeLineDataByFiles: (codeCoverage coverallsSourceFilesIn: self projectDirectory)].