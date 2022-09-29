helpers
methodIsTraitMethod: aCompiledMethod

	^ (aCompiledMethod respondsTo: #isTraitMethod)
		and: [aCompiledMethod isTraitMethod]