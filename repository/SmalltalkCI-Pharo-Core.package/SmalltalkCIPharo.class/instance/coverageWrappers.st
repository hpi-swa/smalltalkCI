coverage
coverageWrappers
	^ self classesToCover 
		gather: [ :cls |
			cls organization allMethodSelectors
				collect: [ :methodSelector |
					TestCoverage on: (self class methodReferenceFor: cls selector: methodSelector)]]