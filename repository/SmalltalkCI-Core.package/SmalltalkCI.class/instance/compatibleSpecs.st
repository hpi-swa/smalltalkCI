accessing
compatibleSpecs 
	^ spec loading select: [ :each | each isPlatformCompatible ]