helpers
deprecated
	| senderMethod methodName |
	senderMethod := (GsProcess _frameContentsAt: 2) first.
	methodName := senderMethod inClass asString, '>>', senderMethod selector asString.
	self printErrorToStdout: methodName, ' is deprecated!'