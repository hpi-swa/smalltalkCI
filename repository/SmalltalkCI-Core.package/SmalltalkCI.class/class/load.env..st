executing
load: aFilenameString env: buildEnvironment
	BuildEnvironment := buildEnvironment.
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		load