travis
endTravisFold: foldName message: aMessage time: aTime
	self printToStdout: ' > ', aMessage, ' in ', (self stringFor: aTime maxDecimalPlaces: 3), 's.'.
	self printTravisFold: foldName startOrEnd: 'end'