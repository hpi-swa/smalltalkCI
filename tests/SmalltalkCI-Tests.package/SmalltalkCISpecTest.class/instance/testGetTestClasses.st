testing
testGetTestClasses
	| classes |
	self spec tests: (Dictionary new
		add: #classes->#(#SmalltalkCISpecTest);
		add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
		yourself).
	classes := self spec getTestClasses.
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: Object).

	self spec tests: (Dictionary new
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