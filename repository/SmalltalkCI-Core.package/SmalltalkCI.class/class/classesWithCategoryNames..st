class organization
classesWithCategoryNames: categoryNames
	| classes |
	classes := Set new.
	categoryNames do: [ :name |
		classes addAll: (self classesInCategory: name) ].
	^ classes