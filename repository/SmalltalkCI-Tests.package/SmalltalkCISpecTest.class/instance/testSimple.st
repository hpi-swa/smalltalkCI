testing
testSimple
	self spec
		configuring: OrderedCollection new;
		specName: 'foo';
		loading: (OrderedCollection with: SCIMetacelloLoadSpec new).

	self
		assert: 0 equals: self spec configuring size;
		assert: 'foo' equals: self spec specName;
		assert: 1 equals: self spec loading size