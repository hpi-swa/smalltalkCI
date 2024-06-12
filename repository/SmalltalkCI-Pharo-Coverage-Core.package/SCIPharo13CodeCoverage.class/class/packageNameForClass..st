compatibility
packageNameForClass: aClass
	^ ((Smalltalk at: #PackageOrganizer) default packageOf: aClass) name