accessing
testError

	self passedUnexpectedly ifTrue: [ 
		^ TestFailure new
			messageText: 'Test passed unexpectedly';
			yourself ].

	^ testError