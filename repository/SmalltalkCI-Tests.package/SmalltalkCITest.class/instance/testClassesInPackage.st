testing
testClassesInPackage
	| classes |
	classes := SmalltalkCI classesInPackage: 'SmalltalkCI-Core'.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest)