tests
testFilterLegalNames
	| coverage targetNames |
	coverage := SmalltalkCI codeCoverageClass new.
	targetNames := {'XYZ'. coverage class ignoredPackages first. 'ZYX'}.
	self
		assert: (coverage filterLegalNames: targetNames)
		equals: #('XYZ' 'ZYX')