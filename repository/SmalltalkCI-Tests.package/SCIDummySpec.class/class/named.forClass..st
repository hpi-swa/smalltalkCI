instance creation
named: aName forClass: aClass
	^ self new
		name: aName;
		classesToTest: {aClass};
		yourself