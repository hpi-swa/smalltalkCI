travis
startTravisFold: foldName title: aTitle
	self printTravisFold: foldName startOrEnd: 'start'.
	self printToStdout: (self ansiBold, self ansiBlue, aTitle, self ansiReset)
	