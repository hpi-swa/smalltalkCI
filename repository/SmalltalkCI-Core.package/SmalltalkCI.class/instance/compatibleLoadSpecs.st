external
compatibleLoadSpecs 
	^ spec loading select: [ :each | each isPlatformCompatible ]