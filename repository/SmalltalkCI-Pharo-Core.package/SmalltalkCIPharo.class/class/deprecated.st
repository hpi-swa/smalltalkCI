helpers
deprecated
	| ctx |
	ctx := thisContext sender sender. "First sender is SmalltalkCI>>deprecated"
	(thisContext sender method methodClass == TestCoverage)
		ifTrue: [ ctx := ctx sender sender "Skip additional TestCoverage senders" ].
	self printErrorToStdout: ctx asString, ' is deprecated!'