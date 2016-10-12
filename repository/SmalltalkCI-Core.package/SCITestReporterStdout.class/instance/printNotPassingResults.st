printing
printNotPassingResults
	| title separator |
	title := '# ', (runner erroredTests + runner failedTests) asString, ' tests did not pass: #'.
	separator := String new: title size withAll: $#.
	self newLine;
		setModeBold; setModeRed; 
		print: separator; newLine;
		print: title; newLine;
		print: separator; newLine.
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printClassTitle: class.
			notPassing do: [ :result | self printResult: result ] ] ]