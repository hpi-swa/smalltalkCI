tests
testFilterLegalNamesStarPatternExclusionPrefixes
	"Patterns which prefix an exclusion are illegal"
	| coverage targetNames |
	coverage := SmalltalkCI codeCoverageClass new.
	targetNames := coverage class ignoredPackages
				withIndexCollect: [:name :index |
					(name allButLast: (1 + index min: name size // 3))
						copyWith: $*].
	self
		assert: (coverage filterLegalNames: targetNames)
		equals: #()