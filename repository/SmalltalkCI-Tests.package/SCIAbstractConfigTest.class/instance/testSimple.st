testing
testSimple
	self config
		configName: 'foo';
		platforms: #(#myplatform #anotherplatform).
	
	self
		assert: 'foo' equals: self config configName;
		assert: 2 equals: self config platforms size;
		assert: true equals: (self config isPlatformCompatible: #myplatform)