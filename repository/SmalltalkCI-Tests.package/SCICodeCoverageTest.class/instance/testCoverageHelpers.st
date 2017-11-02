testing
testCoverageHelpers
	| cc |
	"Coverage testing is only supported on Squeak and Pharo"
	(SmalltalkCI platformSymbol = #squeak or:
		[ SmalltalkCI platformSymbol = #pharo ])
			ifFalse: [ ^ self ].
	
	self assert: false equals: (SmalltalkCI platformClass fileExists: self class testFilePath).
	
	[ self createTestFile.
	cc := SmalltalkCI codeCoverageClass new.
	self assert: 2 equals: (cc linesOf: self class testFilePath).
	self assert: 'ac52b72be23970e756614f929e640fba' equals: (cc md5Of: self class testFilePath) ]
		ensure: [ self deleteTestFile ]