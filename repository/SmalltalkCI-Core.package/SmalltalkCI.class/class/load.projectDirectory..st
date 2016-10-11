public-api
load: aFilenameString projectDirectory: aDirectoryPathString
	^ self newInstance
		readSTONSpec: aFilenameString;
		projectDirectory: aDirectoryPathString;
		load