printing
printNotPassingResults
	| title separator |
	title := '# ', (runner erroredTests + runner failedTests) asString, ' tests did not pass: #'.
	separator := String new: title size withAll: $#.
	self newLine;
		setModeBoldRed; print: separator; newLine;
		setModeBoldRed; print: title; newLine;
		setModeBoldRed; print: separator; newLine.
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printClassTitle: class.
			notPassing do: [ :result | self printResult: result ] ] ]