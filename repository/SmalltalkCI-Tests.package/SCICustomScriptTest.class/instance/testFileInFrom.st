testing
testFileInFrom
	self withTestFileDo: [ :testFile | | filename dirname |
		filename := SmalltalkCI basename: testFile.
		dirname := SmalltalkCI dirname: testFile.
		(SCICustomScript newForPath: filename) fileInFrom: dirname.
		self assert: (Smalltalk at: #SCICustomScriptTestFileResult).
		Smalltalk at: #SCICustomScriptTestFileResult put: nil ]