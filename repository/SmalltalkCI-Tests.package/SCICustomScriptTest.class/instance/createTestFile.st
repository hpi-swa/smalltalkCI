helpers
createTestFile
	| stream |
	stream := SmalltalkCI forceNewFileNamed: self class testFilePath.
	stream nextPutAll: 'Smalltalk at: #SCICustomScriptTestFileResult put: true.'.
	stream close