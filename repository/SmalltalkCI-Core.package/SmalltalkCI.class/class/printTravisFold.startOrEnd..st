travis
printTravisFold: foldName startOrEnd: startOrEnd
	self isTravisBuild ifFalse: [ ^ self ].
	self stdout cr; nextPutAll: (self travisFold: foldName startOrEnd: startOrEnd); cr