setup
startUp
	| methods |
	methods := self allMethodReferencesToCover.
	excludedMethods := methods select: [ :method | self class isExcluded: method ].
	includedMethods := methods copyWithoutAll: excludedMethods.
	coverageWrappers := includedMethods collect: [ :each | (Smalltalk at: #TestCoverage) on: each ].
	coverageWrappers do: [ :each | each install ]