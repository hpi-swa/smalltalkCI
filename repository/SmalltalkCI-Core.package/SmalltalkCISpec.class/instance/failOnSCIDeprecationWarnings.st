helpers
failOnSCIDeprecationWarnings
	^ self testing at: #failOnSCIDeprecationWarnings ifAbsent: [ false ]