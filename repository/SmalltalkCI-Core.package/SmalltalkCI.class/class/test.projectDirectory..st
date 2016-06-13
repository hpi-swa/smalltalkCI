executing
test: aFilenameString projectDirectory: aDirectoryPathString
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		projectDirectory: aDirectoryPathString;
		test