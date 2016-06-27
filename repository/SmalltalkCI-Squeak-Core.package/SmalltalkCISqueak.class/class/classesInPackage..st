class organization
classesInPackage: packageName
	| package |
	package := (Smalltalk at: #PackageOrganizer) default packageNamed: packageName ifAbsent: [ ^ #() ].
	^ package classes