testing
testAddLoadedClassesFrom
	| mcOrganization |
	self assert: true equals: (self spec loadedClasses isEmpty).
	
	mcOrganization := MCOrganizationDefinition categories: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').
	self spec addLoadedClassesFrom: {mcOrganization}.
	self assert: false equals: (self spec loadedClasses isEmpty).
	self assert: true equals: (self spec loadedClasses includes: SmalltalkCI).
	self assert: false equals: (self spec testClasses includes: SmalltalkCI).
	self assert: true equals: (self spec testClasses includes: SmalltalkCITest).