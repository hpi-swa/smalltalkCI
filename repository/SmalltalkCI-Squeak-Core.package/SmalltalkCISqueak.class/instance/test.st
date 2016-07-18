executing
test
	super test.
	self class isHeadless ifTrue: [ self class closeImageWithExitCode: 0 ]