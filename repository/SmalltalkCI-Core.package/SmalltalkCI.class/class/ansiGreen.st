ansi
ansiGreen
	^ self isColorful
		ifTrue: [ self escape, '[32m' ]
		ifFalse: [ '' ]