exporting
export: codeCoverage in: projectDirectory

	self projectDirectory: projectDirectory.
	SmalltalkCI printToStdout: 'Writing LCOV coverage info to: ', self lcovResultFilename ansiColor: SmalltalkCI ansiBlue, SmalltalkCI ansiBold.
	self exportCoverallsData: (codeCoverage coverallsSourceFilesIn: self projectDirectory).