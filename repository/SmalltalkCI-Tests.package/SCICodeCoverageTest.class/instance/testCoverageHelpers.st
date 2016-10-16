testing
testCoverageHelpers
	| cc |
	"Coverage testing is only supported on Squeak and Pharo"
	(SmalltalkCI platformSymbol = #squeak or:
		[ SmalltalkCI platformSymbol = #pharo ])
			ifFalse: [ ^ self ].
	
	self assert: false equals: (SmalltalkCI platformClass fileExists: self class coverageTestFile).
	
	[ self createTestFile.
	cc := SmalltalkCI codeCoverageClass new.
	self assert: 2 equals: (cc linesForFile: self class coverageTestFile).
	self assert: 'ac52b72be23970e756614f929e640fba' equals: (cc md5ForFile: self class coverageTestFile) ]
		ensure: [ self deleteTestFile ]