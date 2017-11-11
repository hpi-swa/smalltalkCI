helpers
suiteName
	^ self testing at: #suiteName ifAbsent: [ self class defaultSuiteName ]