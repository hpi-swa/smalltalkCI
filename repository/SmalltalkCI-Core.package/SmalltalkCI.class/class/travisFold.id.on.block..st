folding
travisFold: aTitle id: anID on: aStream block: aBlock
	| foldName |
	foldName := anID copyReplaceAll: '>>#' with: '_'.
	aStream nextPutAll: (self travisFold: foldName action: 'start').
	[ self travisTime: aTitle foldName: foldName on: aStream block: aBlock]
		ensure: [aStream nextPutAll: (self travisFold: foldName action: 'end') ]