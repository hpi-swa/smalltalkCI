helpers
eventualOriginalTraitMethodFor: aCompiledMethod

	^ (aCompiledMethod respondsTo: #eventualOriginalTraitMethod)
		and: [aCompiledMethod eventualOriginalTraitMethod]