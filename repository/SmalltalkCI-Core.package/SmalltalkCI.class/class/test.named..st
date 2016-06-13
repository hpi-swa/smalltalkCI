executing
test: aFilenameString named: aString
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		suiteName: aString;
		test