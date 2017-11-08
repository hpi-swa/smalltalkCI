compatibility
isPlatformCompatible
	Smalltalk at: #'SystemVersion' ifPresent: [ :cl |
		| versionString |
		versionString := cl current version.
		^ (versionString beginsWith: 'Pharo')
	       and: [ self allSubclasses noneSatisfy: [ :ea | ea isPlatformCompatible ] ] ].
	^ false