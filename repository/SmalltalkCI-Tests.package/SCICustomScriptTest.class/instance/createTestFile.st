helpers
createTestFile
	| stream |
	stream := SmalltalkCI forceNewFileNamed: self fullTestFilePath.
	stream nextPutAll: 'Smalltalk at: #SCICustomScriptTestFileResult put: true.'.
	stream close