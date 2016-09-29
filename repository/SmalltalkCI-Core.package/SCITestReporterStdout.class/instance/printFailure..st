printing
printFailure: aResult
	self
		printTravisFold: aResult testCase asString startOrEnd: 'start';
		setModeBold; setModeYellow;
		print: ' ', self class ballot, ' ';
		printTestTitle: aResult;
		resetMode; setModeBold;
		print: aResult testError asString; newLine;
		resetMode.
	aResult testStack ifNotNil: [
		self
			print: aResult testStack; newLine;
			resetMode ].
	self  printTravisFold: aResult testCase asString startOrEnd: 'end'.