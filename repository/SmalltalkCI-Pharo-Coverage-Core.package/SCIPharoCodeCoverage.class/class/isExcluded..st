helpers
isExcluded: aMethodReference

	^ ( super isExcluded: aMethodReference )
		or: [ aMethodReference compiledMethod refersToLiteral: #ignoreForCoverage ]