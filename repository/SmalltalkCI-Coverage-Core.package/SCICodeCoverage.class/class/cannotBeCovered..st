helpers
cannotBeCovered: aMethodReference
	"Answer true is aMethodReference is not suitable for covering, such as an abstract method or a method derived from a trait."

	^ aMethodReference compiledMethod isAbstract
		or: [self methodIsTraitMethod: aMethodReference compiledMethod "trait methods are derived from a method in a trait - only the original method is relevant for us"]