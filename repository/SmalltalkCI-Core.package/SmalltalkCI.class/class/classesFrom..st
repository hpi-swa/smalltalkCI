class organization
classesFrom: aDictionary
	| classes |
	classes := Set new.
	aDictionary at: #classes
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary at: #categories
		ifPresent: [ :categoryNames |
			classes addAll: (self classesWithCategoryNames: categoryNames) ].

	aDictionary at: #packages
		ifPresent: [ :packageNames |
			classes addAll: (self classesWithPackageNames: packageNames) ].

	^ classes