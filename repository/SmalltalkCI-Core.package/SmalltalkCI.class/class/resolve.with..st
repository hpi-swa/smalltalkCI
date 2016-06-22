class organization
resolve: unresolvedName with: knownNames
	unresolvedName last = $* ifTrue: [ | start |
		start := unresolvedName allButLast.
		"Treat .* similar to just *"
		(start isEmpty not and: [ start last = $. ])
			ifTrue: [ start := start allButLast ].
		start ifEmpty: [ ^ knownNames ].
		^ knownNames select: [ :ea | ea beginsWith: start ] ].
	^ knownNames select: [ :ea | ea = unresolvedName ]