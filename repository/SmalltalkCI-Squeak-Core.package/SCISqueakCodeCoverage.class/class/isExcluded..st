helpers
isExcluded: aMethodReference

	^ (super isExcluded: aMethodReference)
		or: [(aMethodReference compiledMethod pragmaAt: #ignoreForCoverage) notNil "support for <Squeak 5.3 where #hasLiteral: does not check pragmas and #hasPragma: does not yet exist"]