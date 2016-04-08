initialization
initializeOn: aTestSuite
	suite := aTestSuite.
	stream := StandardFileStream forceNewFileNamed: suite name , '.xml'.
	stream := MultiByteFileStream newFrom: stream.