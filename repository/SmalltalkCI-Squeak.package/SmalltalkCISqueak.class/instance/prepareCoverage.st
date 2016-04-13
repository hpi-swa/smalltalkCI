coverage
prepareCoverage

	coverageWrappers := (self classesToCover 
		gather: [ :cls |
			cls organization allMethodSelectors
				collect: [ :methodSelector |
					TestCoverage on: (MethodReference class: cls selector: methodSelector)]]).
	coverageWrappers do: [ :each | each install ]