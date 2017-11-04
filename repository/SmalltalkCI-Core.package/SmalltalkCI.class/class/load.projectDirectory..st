public-api
load: aFilenameString projectDirectory: aDirectoryPathString
	ProjectDirectory := aDirectoryPathString.
	^ self newInstance
		readSTONSpec: aFilenameString;
		load