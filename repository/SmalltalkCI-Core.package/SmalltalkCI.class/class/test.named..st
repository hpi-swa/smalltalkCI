public-api
test: aFilenameString named: aString
	^ self newInstance
		readSTONSpec: aFilenameString;
		suiteName: aString;
		test