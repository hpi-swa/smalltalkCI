testing
testPrepareAndFinish
	self should: [ self spec prepareForCI ] raise: Error.
	self should: [ self spec finishUpAfterCI ] raise: Error.