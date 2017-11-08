compatibility
isPlatformCompatible
	Smalltalk at: #'SystemVersion' ifPresent: [ :cl |
		| versionString |
		versionString := cl current version.
		^ (versionString beginsWith: 'Pharo7') ].
	^ false