executing
addLoadedClassesFrom: goferReferences
	self loadedClasses addAll: (
		SmalltalkCI classesWithPackageNames: (
			goferReferences collect: [ :ref | ref packageName ] ))