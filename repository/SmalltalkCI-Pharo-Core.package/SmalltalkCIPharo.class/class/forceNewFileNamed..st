compatibility
forceNewFileNamed: aFile
	^ MultiByteFileStream newFrom: (StandardFileStream forceNewFileNamed: aFile)