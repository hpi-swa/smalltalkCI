setup
deleteTestFile
	(SmalltalkCISqueak fileExists: self class coverageTestFile)
		ifTrue: [ SmalltalkCISqueakTest deleteFile: self class coverageTestFile ]