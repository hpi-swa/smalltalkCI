accessing
testError

	self passedUnexpectedly
		ifTrue: [ | error |
			error := TestFailure new.
			error messageText: 'Test passed unexpectedly'.
			^ error ].

	^ testError