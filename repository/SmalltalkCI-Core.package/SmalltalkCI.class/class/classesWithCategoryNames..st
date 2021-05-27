class organization
classesWithCategoryNames: categoryNames
	| classes |
	classes := Set new.
	categoryNames do: [ :eachName |
		classes addAll: (self classesInCategory: eachName) ].
	^ classes