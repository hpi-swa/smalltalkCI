accessing
failed
	testError
		ifNil: [ ^ (self testCase shouldPass not) ]
		ifNotNil: [ ^ testCase shouldPass and: [ testError isKindOf: TestFailure ] ]