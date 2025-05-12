helpers
filterLegalNames: targetNames
	"A category or package pattern is legal if it does not prefix an exclusion pattern.
	System classes are ignored to prevent infinite recursion during coverage testing."
	| exclusions |
	exclusions := self class ignoredPackages.
	^ targetNames select: [ :name |
		  name last ~= $* or: [ "only verify patterns"
			  | prefix |
			  prefix := (name atLast: 2) = $.
				            ifTrue: [ name allButLast: 2 ]
				            ifFalse: [ name allButLast ].
			  exclusions noneSatisfy: [ :exclusion |
				  exclusion beginsWith: prefix ] ] ]