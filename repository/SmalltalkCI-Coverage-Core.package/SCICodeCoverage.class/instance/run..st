executing
run: aBlock
	self startUp.
	[ ^ aBlock value ]
		ensure:	[ self finishUp ]