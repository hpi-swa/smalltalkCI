testing
testIsExcluded

	self
		assert: ( SmalltalkCI codeCoverageClass isExcluded: self class >> #methodToIgnoreInCoverage );
		deny: ( SmalltalkCI codeCoverageClass isExcluded: self class >> #testIsExcluded )