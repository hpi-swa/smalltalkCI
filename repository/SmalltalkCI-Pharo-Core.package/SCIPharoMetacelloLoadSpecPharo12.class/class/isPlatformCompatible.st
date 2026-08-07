compatibility
isPlatformCompatible
	^ super isPlatformCompatible and: [
		SystemVersion current major >= 12 ]