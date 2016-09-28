travis
printTravisFold: foldName startOrEnd: startOrEnd
	self isTravisBuild ifFalse: [ ^ self ].
	self stdout nextPutAll: (self travisFold: foldName startOrEnd: startOrEnd)