executing
test: aFilenameString
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		test