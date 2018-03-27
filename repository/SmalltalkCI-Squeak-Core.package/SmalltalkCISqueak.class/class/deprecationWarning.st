helpers
deprecationWarning
	| ctx |
	ctx := thisContext sender sender. "First sender is SmalltalkCI>>deprecated"
	(thisContext sender method methodClass == SCICoverageWrapper)
		ifTrue: [ ctx := ctx sender sender "Skip additional SCICoverageWrapper senders" ].
	^ ctx asString