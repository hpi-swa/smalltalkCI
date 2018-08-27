accessing
title
	| timeString skippedText |
	timeString := SmalltalkCI stringFor: self time maxDecimalPlaces: 0.
	skippedText := self skipped ifTrue: [ 'skipped, ' ] ifFalse: [ '' ].
	^ self asString, ' (', skippedText, timeString, 'ms)'