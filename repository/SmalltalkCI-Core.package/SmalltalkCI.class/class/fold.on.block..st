folding
fold: aTitle on: aStream block: aBlock
	| timeToRun |
	aStream nextPutAll: (self foldTitle: aTitle); flush.
	timeToRun := self timeToRun: [ aBlock value ].
	aStream nextPutAll: self newLine, ' > Done in ', (self stringFor: timeToRun maxDecimalPlaces: 3), 'ms.', self newLine; flush