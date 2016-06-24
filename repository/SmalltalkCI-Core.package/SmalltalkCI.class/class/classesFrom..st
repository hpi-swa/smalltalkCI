class organization
classesFrom: aDictionary
	| classes |
	classes := Set new.
	aDictionary at: #classes
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary at: #categories
		ifPresent: [ :categories |
			classes addAll: (self classesForCategories: categories) ].

	aDictionary at: #packages
		ifPresent: [ :packages |
			classes addAll: (self classesForPackages: packages) ].
		
	aDictionary at: #'projects'
		ifPresent: [ :projectsList |
			classes addAll: (self classesOfProjects: projectsList) ].

	^ classes