printing
printPass: aResult
	self
		setModeGreen;
		print: ' ', self class checkMark;
		resetMode;
		printTestTitle: aResult; cr