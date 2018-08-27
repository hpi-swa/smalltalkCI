accessing
passed
	testCase shouldPass
		ifTrue: [ ^ testError isNil ]
		ifFalse: [ ^ testError isNil not ]