printing
printEnd
	self newLine; newLine; setModeBold.
	result erroredTests > 0
		ifTrue: [ self setModeRed ]
		ifFalse: [
			result failedTests > 0
				ifTrue: [ self setModeYellow ]
				ifFalse: [ self setModeGreen ] ].

	self
		print: '  Executed ', result summary, '.';
		resetMode; newLine; newLine