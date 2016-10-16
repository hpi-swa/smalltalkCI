helpers
deleteTestFile
	| testFile |
	testFile := self class coverageTestFile.
	(SmalltalkCI platformClass fileExists: testFile)
		ifTrue: [ SmalltalkCI platformClass deleteFile: testFile ]