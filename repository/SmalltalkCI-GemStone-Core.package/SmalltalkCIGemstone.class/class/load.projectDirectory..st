executing-deprecated
load: aFilenameString projectDirectory: aDirectoryPathString
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		projectDirectory: aDirectoryPathString;
		load