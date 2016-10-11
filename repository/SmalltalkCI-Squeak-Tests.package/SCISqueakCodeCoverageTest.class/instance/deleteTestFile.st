setup
deleteTestFile
	(SmalltalkCISqueak fileExists: self class coverageTestFile)
		ifTrue: [ SCISqueakCodeCoverageTest deleteFile: self class coverageTestFile ]