testing
testAddLoadedClassesFrom
	| goferClass gofer |
	goferClass := Smalltalk
		at: #Gofer
		ifAbsent: [ ^ self ].
	
	self assert: true equals: (self spec loadedClasses isEmpty).
	
	gofer := goferClass new
		package: 'SmalltalkCI-Core';
		package: 'SmalltalkCI-Tests'.
	self spec addLoadedClassesFrom: gofer references.
	self deny: (self spec loadedClasses isEmpty).
	self assert: (self spec loadedClasses includes: SmalltalkCI).
	self assert: (self spec loadedClasses includes: SmalltalkCITest).