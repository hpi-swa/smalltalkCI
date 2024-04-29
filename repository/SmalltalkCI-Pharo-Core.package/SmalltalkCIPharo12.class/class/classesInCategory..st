class organization
classesInCategory: aCategory
	^ (Smalltalk organization packageMatchingExtensionName: aCategory)
		ifNotNil: [ :package | package definedClasses ]
		ifNil: [ #() ]
