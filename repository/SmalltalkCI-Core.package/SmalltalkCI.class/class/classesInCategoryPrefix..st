private helpers
classesInCategoryPrefix: aCategoryPrefix
	| classes |
	classes := Set new.
	(Smalltalk organization categories
		select: [ :category | category beginsWith: aCategoryPrefix ])
			do: [ :category |
				classes addAll: (self classesInCategory: category) ].
	^ classes