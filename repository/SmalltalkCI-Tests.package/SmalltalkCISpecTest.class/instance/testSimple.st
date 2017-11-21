testing
testSimple
	self spec
		configuring: OrderedCollection new;
		loading: (OrderedCollection with: SCIMetacelloLoadSpec new).

	self
		assert: 0 equals: self spec configuring size;
		assert: 1 equals: self spec loading size