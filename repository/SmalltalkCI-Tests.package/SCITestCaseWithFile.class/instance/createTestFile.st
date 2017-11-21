file-handling
createTestFile
	self assert: false equals: (SmalltalkCI platformClass fileExists: self fullTestFilePath).
	SmalltalkCI
		forceNewFileNamed: self fullTestFilePath
		do: [ :stream | stream nextPutAll: self class testFileContents ]