printing
printStart
	self cr;
		setModeBoldBlue; print: self class separator; cr;
		setModeBoldBlue; print: '# ', runner suite name; cr;
		setModeBoldBlue; print: '# ', runner totalTests asString, ' Tests, ';
		print: '', runner failedTests asString, ' Failures, ';
		print: '', runner erroredTests asString, ' Errors ';
		print: 'in ', (runner suiteTimeInSeconds roundTo: 0.01) asString, 's'; cr;
		setModeBoldBlue; print: self class separator; cr; cr;
		resetMode