testing
testClassesForPackages
	| classes size |
	classes := SmalltalkCI classesForPackages: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesForPackages: #('SmalltalkCI-Cor.*' 'SmalltalkCI-T.*').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInPackage: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInPackage: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.