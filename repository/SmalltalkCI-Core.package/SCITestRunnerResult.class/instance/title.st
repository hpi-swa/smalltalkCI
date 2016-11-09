accessing
title
	| timeString |
	timeString := SmalltalkCI stringFor: self time maxDecimalPlaces: 0.
	^ self asString, ' (', timeString, 'ms)'