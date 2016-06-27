helpers
printToStdout: msg
	self platformClass stdout cr; nextPutAll: msg; cr; flush