tests
testLcovEndToEnd
	| fileContents projDir |
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	projDir := SmalltalkCI buildDirectory.
	SCILcovWriter new
		spec: self class lcovSpec;
		projectDirectory: projDir;
		exportCoverallsData: self class mockLineCoverage.

	SmalltalkCI
		readOnlyFileNamed: projDir, SmalltalkCI pathNameDelimiter, 'coverage', SmalltalkCI pathNameDelimiter, 'lcov.info'
		do: [:stream | fileContents := stream contents].
	
	self assert: (self class lcovEndToEndOutputIn: projDir) withUnixLineEndings
		equals: fileContents.