testing
testIsComplete
	self assert: (self spec isComplete) equals: false.
	
	self spec platform: #bogus.
	self spec
		baseline: 'Foo';
		platform: SCISpec platformSymbol.
	self assert: (self spec isComplete) equals: true.
	
	self spec platform: #bogus.
	self spec
		baseline: nil;
		configuration: 'Foo';
		platform: SCISpec platformSymbol.
	self assert: (self spec isComplete) equals: true.
	
	