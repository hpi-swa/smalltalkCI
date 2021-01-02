exporting
export: codeCoverage in: projectDirectory

	codeCoverage includedMethods 
		ifEmpty: [
			self sci printToStdout: 'No methods included in coverage!' ansiColor: self sci ansiBold, self sci ansiYellow.
			self sci printlnToStdout:  'Please check that your .smalltalk.ston is configured correctly.' ansiColor: self sci ansiBold, self sci ansiYellow.
			self sci printlnToStdout: 'See: https://github.com/hpi-swa/smalltalkCI/blob/master/docs/COVERAGE.md' ansiColor: self sci ansiBold, self sci ansiYellow]
		ifNotEmpty: [self printNonEmptyCoverage: codeCoverage].