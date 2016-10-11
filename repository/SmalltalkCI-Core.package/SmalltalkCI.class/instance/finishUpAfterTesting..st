executing
finishUpAfterTesting: buildSuccessful
	self exportBuildStatus: buildSuccessful.
	SmalltalkCI isHeadless
		ifTrue: [ self finishUpAfterTestingHeadless: buildSuccessful ]
		ifFalse: [ self finishUpAfterTestingHeadful: buildSuccessful ]