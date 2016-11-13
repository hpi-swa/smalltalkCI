helpers
hidePassingResults
	^ self testing at: #hidePassingResults ifAbsent: [ false ]