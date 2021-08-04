ansi
ansiBold
	^ self isColorful
		ifTrue: [ self escape, '[1m' ]
		ifFalse: [ '' ]