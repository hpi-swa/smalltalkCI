printing
printPass: aResult
	self
		setModeGreen;
		print: ' ', self class checkMark;
		resetMode;
		print: ' ', (aResult testCase asString); cr