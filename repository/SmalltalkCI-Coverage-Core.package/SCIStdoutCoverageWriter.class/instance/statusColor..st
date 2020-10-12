exporting
statusColor: aCoveragePercentage
	"Use a traffic-light style color to indicate quality of code coverage"
	^ aCoveragePercentage > 90
		ifTrue: [self sci ansiGreen]
		ifFalse: [aCoveragePercentage < 80
			ifTrue: [self sci ansiRed]
			ifFalse: [self sci ansiYellow]]