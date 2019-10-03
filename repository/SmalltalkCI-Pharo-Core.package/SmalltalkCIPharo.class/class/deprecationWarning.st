helpers
deprecationWarning

	| ctx sender |

	"First sender is SmalltalkCI>>deprecated"
	ctx := thisContext sender sender.
	"Skip additional SCICoverageWrapper senders"
	sender := thisContext sender.
	Smalltalk
		at: #SCICoverageWrapper
		ifPresent: [ :coverageWrapperClass |
			sender method methodClass == coverageWrapperClass
				ifTrue: [ ctx := ctx sender sender ]
			].
	^ ctx asString