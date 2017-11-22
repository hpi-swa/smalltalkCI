executing
run: aBlock spec: aSmalltalkCISpec
	self spec: aSmalltalkCISpec.
	[self startUp.
	[ ^ aBlock value ]
		ensure:	[ self finishUp ]] valueUnpreemptively