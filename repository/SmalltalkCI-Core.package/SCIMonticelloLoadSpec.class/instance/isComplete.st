testing
isComplete
	self url ifNil: [ ^ false ].
	((self packages isNil or: [ self packages isEmpty ]) and: [
		self versions isNil or: [ self versions isEmpty ] ])
			ifTrue: [ ^ false ].
	^ true