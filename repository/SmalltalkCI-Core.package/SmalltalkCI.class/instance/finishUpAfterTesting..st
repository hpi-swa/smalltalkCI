executing
finishUpAfterTesting: buildSuccessful
	self exportBuildStatus: buildSuccessful.
	self class isHeadless
		ifTrue: [ self finishUpAfterTestingHeadless: buildSuccessful ]
		ifFalse: [ self finishUpAfterTestingHeadful: buildSuccessful ]