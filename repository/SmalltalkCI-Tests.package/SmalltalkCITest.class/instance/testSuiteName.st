testing
testSuiteName
	self assert: self sci suiteName equals: SmalltalkCI defaultSuiteName.
	self sci suiteName: 'fooSuite'.
	self assert: self sci suiteName equals: 'fooSuite'
	