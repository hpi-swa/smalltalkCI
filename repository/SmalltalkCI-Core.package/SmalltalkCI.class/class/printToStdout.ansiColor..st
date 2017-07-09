helpers
printToStdout: msg ansiColor: ansiColor
	self stdout cr; nextPutAll: ansiColor, msg, self ansiReset; cr; flush