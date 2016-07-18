printing
printEnd
	runner erroredTests > 0
		ifTrue: [ self setModeBold; setModeRed ]
		ifFalse: [
			runner failedTests > 0
				ifTrue: [ self setModeBold; setModeYellow ]].

	self cr; cr;
		print: '    Executed ', runner suite tests size asString, ' tests';
		print: ', with ', runner failedTests asString, ' failures';
		print: ', and ', runner erroredTests asString, ' errors';
		print: ' in ', runner suiteTimeInSeconds asString, 's.';
		cr; cr;
		resetMode