setup
installCoverageWrappers
	coverageWrappers := self methodsToCover collect: [ :each | (Smalltalk at: #TestCoverage) on: each ].
	coverageWrappers do: [ :each | each install ]