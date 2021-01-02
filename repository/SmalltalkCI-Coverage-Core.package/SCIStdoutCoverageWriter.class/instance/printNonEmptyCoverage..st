exporting
printNonEmptyCoverage: codeCoverage

	| coveragePercentage |
	self printCoverageDetails: codeCoverage.
	
	"The includedMethods should never be empty. But still use 1 to avoid Divide by Zero, just in case."
	coveragePercentage := codeCoverage coveredMethods size / (codeCoverage includedMethods size max: 1) * 100.
	self sci
		printToStdout: 'Covered ', codeCoverage coveredMethods size asString, '/', codeCoverage includedMethods size asString, ' methods (', (coveragePercentage printShowingDecimalPlaces: 2), '%) during testing.'
		ansiColor: (self statusColor: coveragePercentage), self sci ansiBold.