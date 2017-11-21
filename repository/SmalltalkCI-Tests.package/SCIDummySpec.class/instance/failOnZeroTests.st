accessing
failOnZeroTests
	^ self testing at: #failOnZeroTests ifAbsent: [ false ]