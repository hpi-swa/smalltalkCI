exporting
export: codeCoverage in: aDirectory

	self projectDirectory: aDirectory.
	SmalltalkCI printToStdout: 'Writing LCOV coverage info to: ', self lcovResultFilename ansiColor: SmalltalkCI ansiBlue, SmalltalkCI ansiBold.
	self exportCoverallsData: (codeCoverage coverallsSourceFilesIn: self projectDirectory).