tests
testFilterLegalNamesNonPatterns
	"Non-patterns are always legal"
	self
		assert: (SmalltalkCI codeCoverageClass new filterLegalNames: #('XYZ' 'ZYX'))
		equals: #('XYZ' 'ZYX')