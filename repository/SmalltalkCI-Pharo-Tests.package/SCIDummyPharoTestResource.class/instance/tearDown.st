running
tearDown
	TearDownCounter := TearDownCounter ifNil: [ 1 ] ifNotNil: [ :i | i + 1 ].
	super tearDown