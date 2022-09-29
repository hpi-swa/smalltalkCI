setup
startUp
	| methods methodsForWrappers |
	methods := self allMethodReferencesToCover.
	excludedMethods := methods select: [ :method | self class isExcluded: method ].
	includedMethods := methods copyWithoutAll: excludedMethods.
	
	"Methods in traits are copied to their users. Wrap these copies as well to catch all evaluations of the original trait method."
	methodsForWrappers := includedMethods , (self eventualUsersForTraitsIn: methods).
	coverageWrappers := methodsForWrappers collect: [ :each | SCICoverageWrapper on: each ].
	coverageWrappers do: [ :each | each install ]