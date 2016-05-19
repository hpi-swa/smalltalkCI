coverage
prepareCoverage
	coverageWrappers := self coverageWrappers.
	coverageWrappers do: [ :each | each install ]