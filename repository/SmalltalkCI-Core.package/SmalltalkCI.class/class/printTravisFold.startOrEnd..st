travis
printTravisFold: foldName startOrEnd: startOrEnd
	self platformClass stdout
		nextPutAll: (self travisFold: foldName startOrEnd: startOrEnd)