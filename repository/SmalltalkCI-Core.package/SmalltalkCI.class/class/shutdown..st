finalizing
shutdown: buildSuccessful
	self isHeadless
		ifTrue: [ self shutdownHeadless: buildSuccessful ]