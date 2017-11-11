instance creation
forClass: aClass withSuiteName: aName
	^ self new
		classesToTest: {aClass};
		suiteName: aName;
		yourself