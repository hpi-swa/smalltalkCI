finalizing
shutdown: buildSuccessful
	self exportBuildStatus: buildSuccessful.
	self isHeadless
		ifTrue: [ self shutdownHeadless: buildSuccessful ]
		ifFalse: [ self shutdownHeadful: buildSuccessful ]