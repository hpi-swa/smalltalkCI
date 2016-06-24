setup
deleteTestFile
	(SmalltalkCISqueak fileExists: self class expectedFile)
		ifTrue: [ SmalltalkCISqueakTest deleteFile: self class expectedFile ]