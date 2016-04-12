private
classesForCategories: anOrderedCollection
	| classes |
	classes := Smalltalk allClasses select: [ :class |
		anOrderedCollection anySatisfy: [ :categoryName |
			class category = categoryName asSymbol ] ].
	^classes collect: [ :each | each asString asSymbol ].
	