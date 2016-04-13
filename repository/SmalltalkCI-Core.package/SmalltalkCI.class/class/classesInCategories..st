private helpers
classesInCategories: aCategoryList
	| classes |
	classes := Set new.
	aCategoryList do: [ :ea |
		(ea last = $*)
			ifTrue: [ classes addAll: (SmalltalkCI classesInCategoryPrefix: ea allButLast) ]
			ifFalse: [ classes addAll: (SmalltalkCI classesInCategory: ea) ] ].
	^ classes