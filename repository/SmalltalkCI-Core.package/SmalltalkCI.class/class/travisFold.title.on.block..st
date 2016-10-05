travis
travisFold: foldName title: aTitle on: aStream block: aBlock
	| timeToRun |
	aStream nextPutAll: (self travisFold: foldName startOrEnd: 'start').
	aStream nextPutAll: (self ansiBold, self ansiBlue, aTitle, self ansiReset).
	[ timeToRun := self timeToRun: [ aBlock value ] ] ensure: [
		aStream nextPutAll: ' > Done in ', (self stringFor: timeToRun maxDecimalPlaces: 3), 's.'.
		aStream nextPutAll: (self travisFold: foldName startOrEnd: 'end') ]