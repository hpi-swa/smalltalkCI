class organization
resolve: name with: knownNames
	name last = $* ifTrue: [ | start |
		start := name allButLast.
		"Treat .* similar to just *"
		(start isEmpty not and: [ start last = $. ])
			ifTrue: [ start := start allButLast ].
		start ifEmpty: [ ^ knownNames ].
		^ knownNames select: [ :ea | ea beginsWith: start ] ].
	^ knownNames select: [ :ea | ea = name ]