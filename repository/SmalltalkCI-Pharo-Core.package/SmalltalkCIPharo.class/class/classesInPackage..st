class organization
classesInPackage: packageName
	| package |
	package := (Smalltalk at: #RPackageOrganizer) default packageNamed: packageName ifAbsent: [ ^ #() ].
	^ package classes