private
requiresLatestMetacello
	"Check for missing features."

	"Credentials parameters (https://github.com/Metacello/metacello/pull/536)"
	(self user isEmptyOrNil not and: [ (Metacello canUnderstand: #username:) not ])
		ifTrue: [ ^ true ].
	(self password isEmptyOrNil not and: [ (Metacello canUnderstand: #password:) not ])
		ifTrue: [ ^ true ].
	
	^ false