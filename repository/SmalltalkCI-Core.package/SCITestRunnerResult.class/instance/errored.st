accessing
errored
	testError
		ifNotNil: [ ^ self testCase shouldPass and: [ (self testError isKindOf: TestFailure) not ] ].
	^ false