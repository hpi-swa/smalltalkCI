accessing
title
	| time |
	time := SmalltalkCI stringFor: self time maxDecimalPlaces: 0.
	^ self name, ' (', time, 'ms)'