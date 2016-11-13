helpers
compatibleLoadSpecs
	^ self loading select: [ :each | each isPlatformCompatible ]