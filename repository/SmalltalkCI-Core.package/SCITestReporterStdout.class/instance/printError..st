printing
printError: aResult
	self
		printTravisFold: aResult testName startOrEnd: 'start';
		setModeBold; setModeRed;
		print: ' ', self class ballot, ' ';
		printTestTitle: aResult;
		resetMode; setModeBold;
		print: aResult testError asString; newLine;
		resetMode.
	aResult testStack ifNotNil: [
		self
			print: aResult testStack; newLine;
			resetMode ].
	self printTravisFold: aResult testName startOrEnd: 'end'.