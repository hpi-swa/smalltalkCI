testing
testAddLoadedClassesFrom
	| mcOrganization |
	self assert: true equals: (self spec loadedClasses isEmpty).

	mcOrganization := (MCOrganizationDefinition canUnderstand: #categories:)
		ifTrue: [
			"Squeak, Pharo < 12"
			MCOrganizationDefinition categories: #('SmalltalkCI-Core' 'SmalltalkCI-Tests') ]
		ifFalse: [
			MCOrganizationDefinition
				packageName: 'SmalltalkCI'
				tagNames: #(Core Tests) ].

	self spec addLoadedClassesFrom: {mcOrganization}.
	self deny: (self spec loadedClasses isEmpty).
	self assert: (self spec loadedClasses includes: SmalltalkCI)