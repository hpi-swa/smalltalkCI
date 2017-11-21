running
runSuite: aTestSuite spec: aSCISpec
	^ self new
		initializeOn: aTestSuite;
		spec: aSCISpec;
		run