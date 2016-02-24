accessing
classesToTestFrom: aDictionary
	| classes |

	classes := Set new.
	
	aDictionary 
		at: #classes 
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary 
		at: #categories 
		ifPresent: [ :categoryList |
			categoryList do: [ :eachCategory |
				(eachCategory last = $*)
					ifTrue: [ classes addAll: (self classesInCategoryPrefix: eachCategory allButLast) ]
					ifFalse: [ classes addAll: (self classesInCategory: eachCategory) ] ] ].

	^ classes	
	