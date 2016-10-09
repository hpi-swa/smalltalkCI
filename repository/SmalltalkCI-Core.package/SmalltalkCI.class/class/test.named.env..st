executing
test: aFilenameString named: aString env: buildEnvironment
	BuildEnvironment := buildEnvironment.
	^ self newInstance;
		readSTONSpec: aFilenameString;
		suiteName: aString;
		test