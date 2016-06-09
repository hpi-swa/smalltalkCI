executing
addLoadedClassesFrom: goferReferences
	| packages |
	packages := goferReferences collect: [ :ref | ref packageName ].
	self loadedClasses addAll: (SmalltalkCI classesInCategories: packages)