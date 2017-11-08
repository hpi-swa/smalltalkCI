helpers
compatibleCustomScripts: aPhase
	^ (self customScripts: aPhase) select: [ :each | each isPlatformCompatible ]