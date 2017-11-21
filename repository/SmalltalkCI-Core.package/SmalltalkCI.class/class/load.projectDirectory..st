public-api
load: aFilenameString projectDirectory: aProjectDirectory
	^ self newInstance
		readSTONSpec: aFilenameString;
		projectDirectory: aProjectDirectory;
		load