file-handling
createTestFile
	| stream |
	self assert: false equals: (SmalltalkCI platformClass fileExists: self fullTestFilePath).
	stream := SmalltalkCI forceNewFileNamed: self fullTestFilePath.
	stream nextPutAll: self class testFileContents.
	stream close