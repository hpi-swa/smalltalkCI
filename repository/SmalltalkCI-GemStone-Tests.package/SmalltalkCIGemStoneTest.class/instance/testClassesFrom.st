testing
testClassesFrom
	| classes |
	self sci testing: (Dictionary new
	  add: #'projects' -> #('GLASS1');
	  add: #'categories' -> #('SmalltalkCI-*');
        add: #'exclude' -> (Dictionary new
		add: #'classes' -> #(SCIExcludedTests);
		yourself);
        add: #'include' -> (Dictionary new
		add: #'classes' -> #(BreakpointTest);
		yourself);
        yourself).

	classes := SmalltalkCIGemstone classesFrom: self sci testing.
	self assert: classes notEmpty.
	self assert: (classes includes: (Smalltalk at: #CachingClassOrganizer)).
	self assert: (classes includes: SystemChangeAnnouncement).
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SCIExcludedTests).
	self assert: (classes includes: (Smalltalk at: #BreakpointTest))