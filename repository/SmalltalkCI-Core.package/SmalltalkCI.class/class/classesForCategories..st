class organization
classesForCategories: unresolvedCategeryNames
	| resolvedNames |
	resolvedNames := self resolveAll: unresolvedCategeryNames with: self allCategoryNames.
	^ self classesWithCategoryNames: resolvedNames