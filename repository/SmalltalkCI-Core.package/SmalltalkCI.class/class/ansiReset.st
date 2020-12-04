ansi
ansiReset
	^ self isColorful
		ifTrue: [ self escape, '[0m' ]
		ifFalse: [ '' ]