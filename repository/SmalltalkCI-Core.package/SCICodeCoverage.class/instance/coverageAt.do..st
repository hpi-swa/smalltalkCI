helpers
coverageAt: aSymbol do: aBlock
	^ self spec coverageDictionary
		at: aSymbol
		ifPresent: aBlock
		ifAbsent: [ #() ]