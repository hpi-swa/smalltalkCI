executing
prepareForLoading
	self class isHeadless
		ifTrue: [ SCISqueakToolSet load ].
	SCISqueakTranscript install