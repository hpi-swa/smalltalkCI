executing
prepareForCI
	self class isHeadless
		ifTrue: [ SCISqueakToolSet load ].
	SCISqueakTranscript install.

	super prepareForCI.