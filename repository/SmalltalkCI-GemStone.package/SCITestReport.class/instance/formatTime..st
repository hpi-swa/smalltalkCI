compatibility
formatTime: aTime
	| time |
	time := aTime.
	(aTime respondsTo: #asMilliSeconds)
    		ifTrue: [ time := aTime asMilliSeconds ].
	^ time / 1000.0
	