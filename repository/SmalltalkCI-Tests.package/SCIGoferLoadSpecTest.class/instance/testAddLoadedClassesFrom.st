testing
testAddLoadedClassesFrom
	| gofer |
	self assert: true equals: (self spec loadedClasses isEmpty).
	
	gofer := Gofer new
		package: 'SmalltalkCI-Core';
		package: 'SmalltalkCI-Tests'.
	self spec addLoadedClassesFrom: gofer references.
	self assert: false equals: (self spec loadedClasses isEmpty).
	self assert: true equals: (self spec loadedClasses includes: SmalltalkCI).
	self assert: false equals: (self spec testClasses includes: SmalltalkCI).
	self assert: true equals: (self spec testClasses includes: SmalltalkCITest).