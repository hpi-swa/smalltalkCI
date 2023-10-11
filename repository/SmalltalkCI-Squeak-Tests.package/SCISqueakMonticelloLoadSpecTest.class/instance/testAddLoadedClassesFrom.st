testing
testAddLoadedClassesFrom
	| mcOrganization |
	self assert: true equals: (self spec loadedClasses isEmpty).

	mcOrganization := MCOrganizationDefinition categories: #('SmalltalkCI-Core' 'SmalltalkCI-Tests').

	self spec addLoadedClassesFrom: {mcOrganization}.
	self deny: (self spec loadedClasses isEmpty).
	self assert: (self spec loadedClasses includes: SmalltalkCI).
	self assert: (self spec loadedClasses includes: SmalltalkCITest)
