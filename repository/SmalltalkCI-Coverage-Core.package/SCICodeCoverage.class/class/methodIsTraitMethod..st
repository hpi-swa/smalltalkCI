helpers
methodIsTraitMethod: aCompiledMethod
	<ignoreForCoverage>

	^ (aCompiledMethod respondsTo: #isTraitMethod)
		and: [aCompiledMethod isTraitMethod]