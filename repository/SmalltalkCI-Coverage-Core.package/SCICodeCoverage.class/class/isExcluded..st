helpers
isExcluded: aMethodReference
	^ (self ignoredSelectors includes: aMethodReference selector)
		or: [aMethodReference compiledMethod hasLiteral: #ignoreForCoverage]
