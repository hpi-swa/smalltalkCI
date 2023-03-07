private
uninstallCustomToolSet
	SCISqueakTranscript uninstall.
	self class isHeadless ifTrue: [
		ToolSet unregister: CommandLineToolSet.
		ToolSet default: originalToolSet ]