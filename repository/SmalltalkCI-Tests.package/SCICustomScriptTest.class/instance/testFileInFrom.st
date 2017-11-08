testing
testFileInFrom
	self assert: false equals: (SmalltalkCI platformClass fileExists: self class testFilePath).
	
	[ self createTestFile.
	(SCICustomScript newForPath: self class testFileName) fileInFrom: self class testFileDirectory.
	self assert: (Smalltalk at: #SCICustomScriptTestFileResult).
	Smalltalk at: #SCICustomScriptTestFileResult put: nil ]
		ensure: [ self deleteTestFile ]