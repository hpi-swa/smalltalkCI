executing
load: aFilenameString env: buildEnvironment
	BuildEnvironment := buildEnvironment.
	^ self newInstance
		readSTONSpec: aFilenameString;
		load