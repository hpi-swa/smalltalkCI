helpers
coverageAt: aSymbol do: aBlock
	^ spec coverageDictionary
		at: aSymbol
		ifPresent: aBlock
		ifAbsent: [ #() ]