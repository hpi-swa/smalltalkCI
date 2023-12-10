testing
testClassesFrom
	| classes testing |
	testing := (Dictionary new
        add: #'classes' -> #(Dictionary);
        add: #'categories' -> #('SmalltalkCI-Core');
        yourself).
	classes := SmalltalkCI platformClass classesFrom: testing.
	self assert: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCI).
	self deny: (classes includes: SmalltalkCITest).
	
	testing := (Dictionary new
        add: #'packages' -> #('SmalltalkCI-Core');
        yourself).
	classes := SmalltalkCI platformClass classesFrom: testing.
	self deny: (classes includes: Dictionary).
	self assert: (classes includes: SmalltalkCI).
	self deny: (classes includes: SmalltalkCITest).

	testing := (Dictionary new
        add: #'packages' -> #('SmalltalkCI-*');
        yourself).
	classes := SmalltalkCI platformClass classesFrom: testing.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SCIExcludedTests)