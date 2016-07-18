initialize-release
initializeOn: aTestSuite
	suite := aTestSuite.
	xmlStream := StandardFileStream forceNewFileNamed: suite name , '.xml'.
	xmlStream := MultiByteFileStream newFrom: xmlStream.