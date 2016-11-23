class organization
classesInPackage: packageName
	^ (self packageNamed: packageName ifAbsent: [ ^ #() ]) classes