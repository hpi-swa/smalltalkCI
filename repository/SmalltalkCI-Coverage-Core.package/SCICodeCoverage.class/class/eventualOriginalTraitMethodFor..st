helpers
eventualOriginalTraitMethodFor: aCompiledMethod

	^ (aCompiledMethod respondsTo: #eventualOriginalTraitMethod)
		ifTrue: [aCompiledMethod eventualOriginalTraitMethod]