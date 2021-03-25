ansi
ansiYellow
	^ self isColorful
		ifTrue: [ self escape, '[33m' ]
		ifFalse: [ '' ]