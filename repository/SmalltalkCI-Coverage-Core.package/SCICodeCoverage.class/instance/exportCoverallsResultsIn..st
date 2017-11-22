coveralls
exportCoverallsResultsIn: projectDirectory
	| data |
	(SmalltalkCI fileExists: self class coverallsBuildDataFilename) ifFalse: [
		SmalltalkCI printToStdout: 'Coveralls data is not available. Skipping coverage testing...'.
		^ self].
	data := self class coverallsBuildData.
	data at: 'source_files' put: (self coverallsSourceFilesIn: projectDirectory).
	SmalltalkCI
		forceNewFileNamed: self class coverallsResultFilename
		do: [ :stream | STON put: data asJsonOnStream: stream ]