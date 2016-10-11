testing
testClassesWithCategoryNames
	| classes size |
	classes := SmalltalkCI classesWithCategoryNames: #('SmalltalkCI-Core').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self deny: (classes includes: SmalltalkCITest).
	self deny: (classes includes: SmalltalkCISpecTest).
	self assert: classes size equals: (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	
	classes := SmalltalkCI classesWithCategoryNames: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').
	self assert: (classes includes: SmalltalkCI).
	self assert: (classes includes: SmalltalkCISpec).
	self assert: (classes includes: SmalltalkCITest).
	self assert: (classes includes: SmalltalkCISpecTest).
	self deny: (classes includes: Object).
	size := (SmalltalkCI classesInCategory: 'SmalltalkCI-Core') size.
	size := size + (SmalltalkCI classesInCategory: 'SmalltalkCI-Tests') size.
	self assert: classes size equals: size.