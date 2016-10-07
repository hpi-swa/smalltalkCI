printing
printException: aResult color: aColor
	self
		printTravisFold: aResult testName action: 'start';
		setModeBold;
		print: aColor, ' ', self class ballot, ' ';
		printTestTitle: aResult;
		resetMode; setModeBold;
		print: aResult testError asString;
		resetMode.
	aResult testStack ifNotNil: [
		self newLine;
			print: aResult testStack;
			resetMode ].
	self printTravisFold: aResult testName action: 'end'.