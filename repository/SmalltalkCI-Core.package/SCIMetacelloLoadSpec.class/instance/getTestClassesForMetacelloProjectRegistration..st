private
getTestClassesForMetacelloProjectRegistration: aClassName
	Smalltalk at: #'MetacelloProjectRegistration' ifPresent: [ :mpr |
		^ (mpr registrationForClassNamed: aClassName
				ifAbsent: [ self error: aClassName printString , ' not registered (loaded)' ])
			currentlyLoadedClassesInProject select: [ :cl | cl inheritsFrom: TestCase ] ].
	^ #()