helpers
hidePassingTests
	^ self testing at: #hidePassingTests ifAbsent: [ false ]