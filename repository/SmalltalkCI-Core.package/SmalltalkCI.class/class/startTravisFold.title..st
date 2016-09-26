travis
startTravisFold: foldName title: aTitle
	self isTravisBuild ifTrue: [
		self printTravisFold: foldName startOrEnd: 'start' ].
	self printToStdout: (self ansiBold, self ansiBlue, aTitle, self ansiReset)
	