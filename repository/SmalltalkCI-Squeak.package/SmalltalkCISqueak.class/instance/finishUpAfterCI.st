executing
finishUpAfterCI
	super finishUpAfterCI.

	self finishUpAfterCoverage.
	SCISqueakTranscript uninstall.
	SCISqueakToolSet unload