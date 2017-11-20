testing
testCoverageHelpers
	| cc |
	"Coverage testing is only supported on Squeak and Pharo"
	(SmalltalkCI platformSymbol = #squeak or:
		[ SmalltalkCI platformSymbol = #pharo ])
			ifFalse: [ ^ self ].
	
	self withTestFileDo: [ :testFile |
		cc := SmalltalkCI codeCoverageClass new.
		self assert: 2 equals: (cc linesOf: testFile).
		self assert: 'ac52b72be23970e756614f929e640fba' equals: (cc md5Of: testFile) ]