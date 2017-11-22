helpers
isExcluded: aMethodReference
	^ (self ignoredSelectors includes: aMethodReference selector)
		or: [ aMethodReference compiledMethod isAbstract
			or: [ aMethodReference compiledMethod refersToLiteral: #ignoreForCoverage ]]