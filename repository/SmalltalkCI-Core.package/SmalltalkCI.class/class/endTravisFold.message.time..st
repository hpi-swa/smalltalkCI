travis
endTravisFold: foldName message: aMessage time: aTime
	self printToStdout: ' > ', aMessage, ' in ', ((aTime / 1000.0) roundTo: 0.001) asString, 's.'.
	self printTravisFold: foldName startOrEnd: 'end'