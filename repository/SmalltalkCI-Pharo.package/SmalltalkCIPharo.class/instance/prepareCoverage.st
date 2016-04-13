coverage
prepareCoverage
	|methods |
	methods := (self classesToCover 
		gather: [ :cls |
			cls organization allMethodSelectors
				collect: [ :methodSelector |
					RGMethodDefinition class: cls selector: methodSelector]]).
	coverageWrappers := methods collect: [ :ea | TestCoverage on: ea ].
	coverageWrappers do: [ :each | each install ]