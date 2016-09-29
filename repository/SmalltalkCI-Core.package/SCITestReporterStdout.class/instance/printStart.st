printing
printStart
	self newLine;
		setModeBoldBlue; print: self class separator; newLine;
		setModeBoldBlue; print: '# ', runner suite name; newLine;
		setModeBoldBlue; print: '# ', runner totalTests asString, ' Tests, ';
		print: '', runner failedTests asString, ' Failures, ';
		print: '', runner erroredTests asString, ' Errors ';
		print: 'in '; printTotalTime; newLine;
		setModeBoldBlue; print: self class separator; newLine; newLine;
		resetMode