testing
testAddSpecs
	self assert: 0 equals: (self spec loadSpecs size).
	self spec addLoadSpec: SCIAbstractLoadSpec new.
	self assert: 0 equals: (self spec loadSpecs size).
	self spec addLoadSpec: SCIMetacelloLoadSpec new.
	self assert: 0 equals: (self spec loadSpecs size).
	self spec addLoadSpec:
		(SCIMetacelloLoadSpec new
			baseline: 'Foo';
			platform: SCISpec platformSymbol).
	self assert: 1 equals: (self spec loadSpecs size).