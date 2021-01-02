exporting
export: codeCoverage in: projectDirectory

	self projectDirectory: projectDirectory.
	SmalltalkCI printToStdout: 'Writing LCOV coverage info to: ', self lcovResultFilename.
	self exportCoverallsData: (codeCoverage coverallsSourceFilesIn: self projectDirectory).