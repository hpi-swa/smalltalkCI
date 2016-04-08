executing
prepareForCI
	self class isHeadless
		ifTrue: [ SCISqueakToolSet load ].
	SCISqueakTranscript install.

	"TODO(@marceltaeumel): Workaround for startup scripts (issue #120)"
	ActiveWorld doOneSubCycle.

	super prepareForCI