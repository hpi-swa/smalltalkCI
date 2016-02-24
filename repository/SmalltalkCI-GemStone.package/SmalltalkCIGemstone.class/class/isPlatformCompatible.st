compatibility
isPlatformCompatible
	Smalltalk at: #'SystemVersion'
		ifPresent: [ :cl | ^ false ].
	^ true