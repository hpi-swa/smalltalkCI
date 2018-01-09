testing
testFromFile
	self withTestFileDo: [ :testFile | | spec |
		spec := SmalltalkCISpec fromFile: testFile.
		self assert: 1 equals: spec loading size.
		self assert: #('SmalltalkCI-*') equals: ((spec testing at: #coverage) at: #categories)]