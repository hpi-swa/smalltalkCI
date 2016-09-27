initialize-release
initialize
	stream := StandardFileStream forceNewFileNamed: runner suite name , '.xml'.
	stream := MultiByteFileStream newFrom: stream.