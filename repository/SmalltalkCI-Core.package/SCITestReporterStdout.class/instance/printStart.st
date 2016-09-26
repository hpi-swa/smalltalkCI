printing
printStart
	self
		setModeBoldBlue; print: self class separator; cr;
		setModeBoldBlue; print: '# ', runner suite name; cr;
		setModeBoldBlue; print: '# ', runner suite tests size asString, ' Tests, ';
		print: '', runner failedTests asString, ' Failures, ';
		print: '', runner erroredTests asString, ' Errors ';
		print: 'in ', runner suiteTimeInSeconds asString, 's'; cr;
		setModeBoldBlue; print: self class separator; cr;
		resetMode