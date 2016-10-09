testing
testSuiteName
	self sci suiteName: 'fooSuite'.
	self assert: self sci suiteName equals: 'fooSuite'
	