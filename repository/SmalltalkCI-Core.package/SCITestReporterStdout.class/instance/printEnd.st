printing
printEnd
	self setModeBold.
	runner erroredTests > 0
		ifTrue: [ self setModeRed ]
		ifFalse: [
			runner failedTests > 0
				ifTrue: [ self setModeYellow ]
				ifFalse: [ self setModeGreen ]].

	self cr; cr;
		print: '    Executed ', runner suite tests size asString, ' tests';
		print: ', with ', runner failedTests asString, ' failures';
		print: ', and ', runner erroredTests asString, ' errors';
		print: ' in ', runner suiteTimeInSeconds asString, 's.';
		cr; cr;
		resetMode