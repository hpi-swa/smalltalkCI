bootstrapping
requireSTON
	self isSTONInstalled ifTrue: [ ^ self ].
    	
	self installSTON.
	self isSTONInstalled 
		ifFalse: [ self error: 'STON could not be loaded.' ]