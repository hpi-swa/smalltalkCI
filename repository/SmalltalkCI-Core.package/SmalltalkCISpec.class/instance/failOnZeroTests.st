helpers
failOnZeroTests
	^ self testing at: #failOnZeroTests ifAbsent: [ true ]