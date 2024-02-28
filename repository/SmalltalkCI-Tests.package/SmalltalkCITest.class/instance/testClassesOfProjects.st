testing
testClassesOfProjects
	| classes |
	classes := SmalltalkCI platformClass classesOfProjects: #('SomeNonExistingProject').
	self assert: classes size = 0.
	
	classes := SmalltalkCI platformClass classesOfProjects: #('SmalltalkCI').
	self assert: classes size > 0.
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec)