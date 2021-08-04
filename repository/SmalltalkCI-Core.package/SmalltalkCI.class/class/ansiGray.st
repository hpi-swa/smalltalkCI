ansi
ansiGray
	^ self isColorful
		ifTrue: [ self escape, '[37m' ]
		ifFalse: [ '' ]