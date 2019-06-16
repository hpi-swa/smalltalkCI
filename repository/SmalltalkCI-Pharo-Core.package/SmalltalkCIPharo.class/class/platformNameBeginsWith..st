helpers
platformNameBeginsWith: aString
	Smalltalk at: #'SystemVersion' ifPresent: [ :cl |
		| versionString |
		versionString := cl current version.
		^ (versionString beginsWith: aString) ].
	^ false