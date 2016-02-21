bootstrapping
requireMetacello
	self isMetacelloInstalled ifTrue: [ ^ self ].
    	
	self installMetacello.
	self isMetacelloInstalled
		ifFalse: [ self error: 'Metacelo could not be loaded.' ]