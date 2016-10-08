printing
printEnd
	self newLine; newLine; setModeBold.
	runner erroredTests > 0
		ifTrue: [ self setModeRed ]
		ifFalse: [
			runner failedTests > 0
				ifTrue: [ self setModeYellow ]
				ifFalse: [ self setModeGreen ] ].

	self
		print: '  Executed ', runner summary, '.';
		resetMode; newLine; newLine