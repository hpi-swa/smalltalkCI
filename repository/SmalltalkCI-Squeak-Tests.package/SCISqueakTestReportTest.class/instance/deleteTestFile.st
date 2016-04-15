setup
deleteTestFile
	(SmalltalkCISqueak fileExists: self class expectedFileName)
		ifTrue: [ SmalltalkCISqueakTest deleteFile: self class expectedFileName ]