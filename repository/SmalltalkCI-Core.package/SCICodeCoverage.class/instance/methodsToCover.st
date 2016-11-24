helpers
methodsToCover
	^ Set new
		addAll: self methodsToCoverForClasses;
		addAll: self methodsToCoverForCategories;
		addAll: self methodsToCoverForPackages;
		asOrderedCollection