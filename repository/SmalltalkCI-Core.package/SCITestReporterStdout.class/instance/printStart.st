printing
printStart
	self
		setModeBold; setModeBlue;
		print: self class separator; cr;
		print: '# ', runner suite name;
		print: ': ', runner suite tests size asString, ' Tests, ';
		print: '', runner failedTests asString, ' Failures, ';
		print: '', runner erroredTests asString, ' Errors ';
		print: 'in ', runner suiteTimeInSeconds asString, 's'; cr;
		print: self class separator; cr;
		resetMode