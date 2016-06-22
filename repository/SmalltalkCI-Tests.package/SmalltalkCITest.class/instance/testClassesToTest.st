testing
testClassesToTest
	| classes |
	self sci spec: (SmalltalkCISpec new testing: (Dictionary new
        add: #'classes' -> #(Dictionary);
        add: #'categories' -> #('SmalltalkCI-Tests');
        yourself)).

	classes := self sci classesToTest.
	self assert: (classes includes: Dictionary).
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	
	self sci spec loading: { SCIMetacelloLoadSpec new baseline: 'SmalltalkCI'; yourself }.
	self sci spec testing: (Dictionary new
	  add: #'allTestCases' -> false;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object ObjectTest);
		yourself);
        yourself).
	classes := self sci classesToTest.
	self deny: (classes includes: Object).
	self assert: (classes includes: ObjectTest).
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).

	self sci spec testing: (Dictionary new
	  add: #'allTestCases' -> true;
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(Object);
		yourself);
        yourself).
	classes := self sci classesToTest.
	self deny: (classes includes: Object).
	self assert: (classes includes: ObjectTest).
	self deny: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).
	
	