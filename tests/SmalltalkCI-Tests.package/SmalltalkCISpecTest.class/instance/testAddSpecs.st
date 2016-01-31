testing
testAddSpecs
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: SCIAbstractLoadSpec new.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec: SCIMetacelloLoadSpec new.
	self assert: 0 equals: (self spec loading size).
	self spec addLoadSpec:
		(SCIMetacelloLoadSpec new
			baseline: 'Foo';
			platforms: { SmalltalkCI platformSymbol }).
	self assert: 1 equals: (self spec loading size).