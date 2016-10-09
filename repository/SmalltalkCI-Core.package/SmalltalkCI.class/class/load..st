public-api
load: aFilenameString
	^ self newInstance
		readSTONSpec: aFilenameString;
		load