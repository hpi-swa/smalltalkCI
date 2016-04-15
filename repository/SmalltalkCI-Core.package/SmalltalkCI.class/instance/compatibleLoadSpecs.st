accessing
compatibleLoadSpecs 
	^ spec loading select: [ :each | each isPlatformCompatible ]