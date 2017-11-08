helpers
createTestFile
	| stream |
	stream := SmalltalkCI forceNewFileNamed: self class testFilePath.
	stream nextPutAll: 'First line', String cr, 'Second line'.
	stream close