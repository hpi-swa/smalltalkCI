ansi
ansiBlue
	^ self isColorful
		ifTrue: [ self escape, '[34m' ]
		ifFalse: [ '' ]