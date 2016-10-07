folding
travisFold: aTitle id: anID on: aStream block: aBlock
	aStream nextPutAll: (self travisFold: anID action: 'start'); flush.
	[ self travisTime: aTitle foldName: anID on: aStream block: aBlock]
		ensure: [aStream nextPutAll: (self travisFold: anID action: 'end'); flush ]