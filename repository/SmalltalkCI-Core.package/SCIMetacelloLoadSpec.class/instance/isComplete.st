testing
isComplete
	(self baseline isNil and: [ self configuration isNil ])
		ifTrue: [ ^ false ].
	^ true