helpers
isCoverageTestingEnabled
	^ SmalltalkCI platformSymbol ~= #gemstone and: [ self spec coverageEnabled ]