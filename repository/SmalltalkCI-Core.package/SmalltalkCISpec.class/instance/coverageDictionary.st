helpers
coverageDictionary
	^ self testing at: #coverage ifAbsent: [ Dictionary new ]