bootstrapping
requireMetacello
	self isMetacelloInstalled ifTrue: [ ^ self ].
    	
	self installMetacello.
	self isMetacelloInstalled
		ifFalse: [ self error: 'Metacello could not be loaded.' ]