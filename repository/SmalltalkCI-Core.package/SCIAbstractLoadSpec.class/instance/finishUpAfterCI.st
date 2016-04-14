testing
finishUpAfterCI
	self isComplete
		ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ].
	"Nothing to clean up"