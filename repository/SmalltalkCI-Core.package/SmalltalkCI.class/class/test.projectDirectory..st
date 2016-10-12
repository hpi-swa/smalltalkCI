public-api
test: aFilenameString projectDirectory: aDirectoryPathString
	^ self newInstance
		readSTONSpec: aFilenameString;
		projectDirectory: aDirectoryPathString;
		test