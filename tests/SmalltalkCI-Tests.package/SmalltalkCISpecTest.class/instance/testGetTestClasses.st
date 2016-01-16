testing
testGetTestClasses
	| classes |
	self spec addLoadSpec: (SCIMetacelloLoadSpec new
		baseline: 'SmalltalkCITests';
		platforms: { SmalltalkCISpec platformSymbol }).

	self spec testing: (Dictionary new
		add: #classes->#(#Dictionary);
		add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: Object).

	self spec testing: (Dictionary new
		add: #classes->#(#SmalltalkCISpecTest);
		add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
		add: #exclude->(Dictionary new
			add: #classes->#(SmalltalkCISpec);
			add: #categories->#('Kernel-Objects');
			yourself);
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: SmalltalkCISpec) not.
	self assert: (classes includes: Object) not.