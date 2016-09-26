helpers
imagePath
	Smalltalk at: #FileLocator ifPresent: [ :fl | ^ fl imageDirectory fullName ].
	^ Smalltalk perform: #imagePath