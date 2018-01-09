file-handling
withTestFileDo: aBlock
	[ self createTestFile.
	aBlock value: self fullTestFilePath ]
		ensure: [ self deleteTestFile ]