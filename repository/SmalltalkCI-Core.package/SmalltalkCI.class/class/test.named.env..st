executing
test: aFilenameString named: aString env: buildEnvironment
	BuildEnvironment := buildEnvironment.
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		suiteName: aString;
		test