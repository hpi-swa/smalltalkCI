helpers
deprecationWarning
	| ctx |
	ctx := thisContext sender sender. "First sender is SmalltalkCI>>deprecated"
	(thisContext sender method methodClass == TestCoverage)
		ifTrue: [ ctx := ctx sender sender "Skip additional TestCoverage senders" ].
	^ ctx asString