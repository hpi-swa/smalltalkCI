ansi
ansiClear
	^ self isColorful
		ifTrue: [ self escape, '[0K' ]
		ifFalse: [ '' ]