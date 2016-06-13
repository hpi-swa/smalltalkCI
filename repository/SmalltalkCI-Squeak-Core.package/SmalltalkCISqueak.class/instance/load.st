executing
load
	super load.
	self class isHeadless ifTrue: [ self class closeAndSaveImage ]