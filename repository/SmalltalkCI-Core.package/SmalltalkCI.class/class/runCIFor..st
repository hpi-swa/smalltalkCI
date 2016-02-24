executing
runCIFor: aFilenameString
	^ self platformClass basicNew 
		initialize;
		runCIFor: aFilenameString