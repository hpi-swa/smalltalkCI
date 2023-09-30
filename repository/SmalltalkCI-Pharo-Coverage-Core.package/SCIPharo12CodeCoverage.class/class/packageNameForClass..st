compatibility
packageNameForClass: aClass
	^ ((Smalltalk at: #RPackageOrganizer) default packageOf: aClass) name