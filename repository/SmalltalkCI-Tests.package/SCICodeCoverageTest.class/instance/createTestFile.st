helpers
createTestFile
	| stream |
	stream := SmalltalkCI forceNewFileNamed: self class coverageTestFile.
	stream nextPutAll: 'First line', String cr, 'Second line'.
	stream close