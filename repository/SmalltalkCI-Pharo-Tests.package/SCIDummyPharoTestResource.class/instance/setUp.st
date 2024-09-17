running
setUp
	super setUp.
	SetUpCounter := SetUpCounter ifNil: [ 1 ] ifNotNil: [ :i | i + 1 ]