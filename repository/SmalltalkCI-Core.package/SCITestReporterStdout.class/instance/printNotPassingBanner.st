printing
printNotPassingBanner
	| title separator |
	title := '# ', (runner erroredTests + runner failedTests) asString, ' tests did not pass: #'.
	separator := String new: title size withAll: $#.
	self newLine;
		setModeBoldRed; print: separator; newLine;
		setModeBoldRed; print: title; newLine;
		setModeBoldRed; print: separator; newLine