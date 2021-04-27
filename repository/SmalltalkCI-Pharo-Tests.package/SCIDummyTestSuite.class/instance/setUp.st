running
setUp 	
	super setUp.
	Counter := Counter ifNil: [ 1 ] ifNotNil: [ :i | i + 1 ]