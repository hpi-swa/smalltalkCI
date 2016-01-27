testing
classesToTestCategories
	| classes |
	
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
	classes := self ci classesToTest.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCISpecTest) not.
	self assert: (classes includes: Object).
		
	self spec testing: (Dictionary new
		add: #categories->#('SmalltalkCI-*' 'Kernel-Objects');
		yourself).
	
	classes := self spec classesToTest.
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: Object).
	self assert: (classes includes: Error) not.
	
	"Test #include:"
	self spec testing: (Dictionary new
		add: #include->(Dictionary new
			add: #classes->#(#Dictionary);
			add: #categories->#('SmalltalkCI-Core' 'Kernel-Objects');
			yourself);
		yourself).
	classes := self spec classesToTest.
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
	classes := self spec classesToTest.
	self assert: (classes includes: SmalltalkCISpecTest).
	self assert: (classes includes: SmalltalkCISpec) not.
	self assert: (classes includes: Object) not