executing
load: aFilenameString
	^ self platformClass basicNew
		initialize;
		readSTONSpec: aFilenameString;
		load