class organization
classesInCategory: aCategory
	^ (Smalltalk organization tagForCategory: aCategory)
		ifNotNil: [ :tag |
			tag classNames collect: [ :className | Smalltalk at: className ] ]
		ifNil: [ #() ]
