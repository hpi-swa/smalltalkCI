public-api
test: aFilenameString named: aName projectDirectory: aProjectDirectory
	^ self newInstance
		readSTONSpec: aFilenameString;
		suiteName: aName;
		projectDirectory: aProjectDirectory;
		test