executing
addLoadedClassesFrom: goferReferences
	self loadedClasses addAll: (
		SmalltalkCI classesInCategories: (
			goferReferences collect: [ :ref | ref packageName ] ))