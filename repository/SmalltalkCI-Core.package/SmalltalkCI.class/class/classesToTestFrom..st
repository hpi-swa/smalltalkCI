private helpers
classesToTestFrom: aDictionary
	| classes |
	classes := OrderedCollection new.
	aDictionary at: #classes 
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary at: #categories 
		ifPresent: [ :categoryList |
			classes addAll: (self classesInCategories: categoryList) ].

	^ classes