printing
printException: aResult
	self
		printTravisFold: aResult foldName action: 'start';
		setModeBold;
		print: aResult ansiTitle;
		newLine;
		setModeBold;
		print: aResult testError asString;
		resetMode.
	aResult stack ifNotNil: [
		self newLine;
			print: aResult stack;
			resetMode ].
	self printTravisFold: aResult foldName action: 'end'