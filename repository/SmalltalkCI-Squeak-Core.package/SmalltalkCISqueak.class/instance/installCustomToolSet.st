private
installCustomToolSet
	self class isHeadless ifTrue: [
		originalToolSet := ToolSet default: CommandLineToolSet ].
	SCISqueakTranscript install