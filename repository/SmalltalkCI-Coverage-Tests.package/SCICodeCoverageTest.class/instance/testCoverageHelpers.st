tests
testCoverageHelpers
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	self withTestFileDo: [ :testFile |
		self assert: 2 equals: (SmalltalkCI codeCoverageClass linesOf: testFile).
		self assert: 'ac52b72be23970e756614f929e640fba' equals: (SmalltalkCI codeCoverageClass md5Of: testFile) ]