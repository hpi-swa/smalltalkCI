executing
addLoadedClassesFrom: aDefinitionsCollection
	| mcOrganization classes |
	mcOrganization := aDefinitionsCollection detect: [ :def | def isOrganizationDefinition ].
	mcOrganization ifNil: [ self error: 'Could not find MCOrganizationDefinition' ].
	classes := SmalltalkCI platformClass classesWithCategoryNames: mcOrganization categories.
	self loadedClasses addAll: classes
