exporting
export: codeCoverage in: projectDirectory

	| coveragePercentage |
	self printCoverageDetails: codeCoverage.
	
	coveragePercentage := codeCoverage coveredMethods size / codeCoverage includedMethods size * 100 roundTo: 0.01.
	self sci
		printToStdout: 'Covered ', codeCoverage coveredMethods size asString, '/', codeCoverage includedMethods size asString, ' methods (', coveragePercentage asString, '%) during testing.'
		ansiColor: (self statusColor: coveragePercentage), self sci ansiBold.