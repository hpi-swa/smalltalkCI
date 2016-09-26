helpers
printToStdout: msg
	self platformClass stdout nextPutAll: msg; cr; flush