public-api
test: aFilenameString projectDirectory: aDirectoryPathString
	ProjectDirectory := aDirectoryPathString.
	^ self newInstance
		readSTONSpec: aFilenameString;
		test