printing
printException: aResult color: aColor
	self
		printTravisFold: aResult foldName action: 'start';
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
	self printTravisFold: aResult foldName action: 'end'.