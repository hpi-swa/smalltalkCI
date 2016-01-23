testing
testGetTestClasses
	| classes |
	self spec addLoadSpec: (SCIMetacelloLoadSpec new
		baseline: 'SmalltalkCITests';
		platforms: { SmalltalkCISpec platformSymbol }).

	"Test explicit test definition"
	self spec testing: (Dictionary new
		add: #classes->#(#Dictionary);
		add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
		add: #include->(Dictionary new
			add: #classes->#(#Dictionary);
			add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
			yourself);
		add: #exclude->(Dictionary new
			add: #classes->#(SmalltalkCISpec);
			add: #categories->#('Kernel-Objects');
			yourself);
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCISpecTest) not.
	self assert: (classes includes: Object).

	"Test #include:"
	self spec testing: (Dictionary new
		add: #include->(Dictionary new
			add: #classes->#(#Dictionary);
			add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
			yourself);
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: Object).

	"Test #exclude:"
	self spec testing: (Dictionary new
		add: #include->(Dictionary new
			add: #classes->#(#SmalltalkCISpecTest);
			add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
			yourself);
		add: #exclude->(Dictionary new
			add: #classes->#(SmalltalkCISpec);
			add: #categories->#('Kernel-Objects');
			yourself);
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: SmalltalkCISpec) not.
	self assert: (classes includes: Object) not.