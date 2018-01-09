helpers
allClassesFromSpec
	^ Set new
		addAll: self classesToCover;
		addAll: self classesToCoverForCategories;
		addAll: self classesToCoverForPackages;
		yourself.