tests
testFilterLegalNamesNonPatternExclusionPrefixes
	"Non-patterns are legal even when they prefix an exclusion"
	| coverage targetNames |
	coverage := SmalltalkCI codeCoverageClass new.
	targetNames := coverage class ignoredPackages
				withIndexCollect: [:name :index |
					name allButLast: (1 + index min: name size // 3)].
	self
		assert: (coverage filterLegalNames: targetNames)
		equals: targetNames