class organization
packageNamed: aString ifAbsent: errorBlock
	^ (Smalltalk at: #PackageOrganizer) default packageNamed: aString ifAbsent: errorBlock