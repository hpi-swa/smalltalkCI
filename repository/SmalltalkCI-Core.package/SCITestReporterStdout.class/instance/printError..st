printing
printError: aResult
	self
		printTravisFold: aResult testCase asString startOrEnd: 'start';
		setModeBold; setModeRed;
		print: ' ', self class ballot, ' ';
		printTestTitle: aResult;
		resetMode; setModeBold;
		print: aResult testError asString; cr;
		resetMode.
	aResult testStack ifNotNil: [
		self
			print: aResult testStack; cr;
			resetMode ].
	self printTravisFold: aResult testCase asString startOrEnd: 'end'.