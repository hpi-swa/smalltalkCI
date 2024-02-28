testing
testClassesForPackages
	| classes size |
	classes := SmalltalkCI platformClass classesForPackages: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI platformClass classesInPackage: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI platformClass classesForPackages: #('SmalltalkCI-Cor.*' 'SmalltalkCI-T.*').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI platformClass classesInPackage: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI platformClass classesInPackage: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.