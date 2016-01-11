testing
testIsComplete
	self assert: (self spec isComplete) equals: false.
	
	self spec
		baseline: 'Foo';
		platforms: { SmalltalkCISpec platformSymbol }.
	self assert: (self spec isComplete) equals: true.

	self spec
		baseline: nil;
		configuration: 'Foo';
		platforms: { SmalltalkCISpec platformSymbol }.
	self assert: (self spec isComplete) equals: true.
	
	