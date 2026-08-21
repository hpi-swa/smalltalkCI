testing
testFromFile
	self withTestFileDo: [ :testFile | | testSpec |
		testSpec := SmalltalkCISpec fromFile: testFile.
		self assert: 1 equals: testSpec loading size.
		self assert: #('SmalltalkCI-*') equals: ((testSpec testing at: #coverage) at: #categories)]