helpers
deprecationWarning

	| ctx |
	"First sender is SmalltalkCI>>deprecated"
	ctx := thisContext sender sender.
	"Skip additional SCICoverageWrapper senders"
	Smalltalk
		at: #SCICoverageWrapper
		ifPresent: [ :coverageWrapperClass |
			thisContext sender method methodClass == coverageWrapperClass
				ifTrue: [ ctx := ctx sender sender ]
			].
	^ ctx asString
