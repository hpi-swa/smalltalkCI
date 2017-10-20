accessing
isCoverageTestingEnabled
	^ SmalltalkCI platformSymbol ~= #gemstone and: [ self spec coverageEnabled ]