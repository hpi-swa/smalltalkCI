helpers
startTravisFold: foldName title: aTitle
	self isTravisBuild ifTrue: [
		self printToStdout: (self travisFold: foldName startOrEnd: 'start') ].
	self printToStdout: (self ansiBold, self ansiBlue, aTitle, self ansiReset)
	