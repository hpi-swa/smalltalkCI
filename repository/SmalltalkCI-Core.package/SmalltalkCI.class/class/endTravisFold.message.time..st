helpers
endTravisFold: foldName message: aMessage time: aTime
	self printToStdout: ' > ', aMessage, ' in ', (aTime / 1000.0) asString, 's.'.
	self isTravisBuild ifTrue: [
		self printToStdout: (self travisFold: foldName startOrEnd: 'end') ]