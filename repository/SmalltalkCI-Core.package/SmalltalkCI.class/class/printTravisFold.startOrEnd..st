travis
printTravisFold: foldName startOrEnd: startOrEnd
	self platformClass stdout
		cr;
		nextPutAll: (self travisFold: foldName startOrEnd: startOrEnd);
		cr