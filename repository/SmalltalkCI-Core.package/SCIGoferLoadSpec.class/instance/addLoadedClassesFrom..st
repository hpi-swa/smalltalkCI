executing
addLoadedClassesFrom: goferReferences
	self loadedClasses addAll: (
		SmalltalkCI platformClass classesWithPackageNames: (
			goferReferences collect: [ :ref | ref packageName ] ))