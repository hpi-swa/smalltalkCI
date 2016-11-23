class organization
packageNamed: aString ifAbsent: errorBlock
	^ (Smalltalk at: #RPackageOrganizer) default packageNamed: aString ifAbsent: errorBlock