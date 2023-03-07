ansi
ansiRed
	^ self isColorful
		ifTrue: [ self escape, '[31m' ]
		ifFalse: [ '' ]