testing
testClassesToTest
	| classes |
	self spec: (SmalltalkCISpec new testing: (Dictionary new
        add: #'classes' -> #(Dictionary);
        add: #'categories' -> #('SmalltalkCI-Tests');
        yourself)).

	classes := self spec classesToTest.
	self assert: (classes includes: Dictionary).
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	
	self spec loading: { SCIMetacelloLoadSpec new baseline: 'SmalltalkCI'; yourself }.
	self spec testing: (Dictionary new
	  add: #'allTestCases' -> false;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object ObjectTest BreakpointTest);
		yourself);
        yourself).
	classes := self spec classesToTest.
	self deny: (classes includes: Object).
	Smalltalk at: #'ObjectTest' ifPresent: [ :ot | self assert: (classes includes: ot) ].
	Smalltalk at: #'BreakpointTest' ifPresent: [ :bt | self assert: (classes includes: bt) ].
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).

	self spec testing: (Dictionary new
	  add: #'allTestCases' -> true;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object);
		yourself);
        yourself).
	classes := self spec classesToTest.
	self deny: (classes includes: Object).
	Smalltalk at: #'ObjectTest' ifPresent: [ :ot | self assert: (classes includes: ot) ].
	Smalltalk at: #'BreakpointTest' ifPresent: [ :bt | self assert: (classes includes: bt) ].
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).
	
	self spec testing: Dictionary new.
	classes := SmalltalkCI platformClass classesFrom: (Dictionary new
        add: #'projects' -> #('SmalltalkCI');
        yourself).
	self spec classesToTest allSatisfy: [ :cl | classes includes: cl]
	