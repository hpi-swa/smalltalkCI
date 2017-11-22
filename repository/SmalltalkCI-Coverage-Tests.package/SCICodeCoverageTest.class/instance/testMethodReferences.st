testing
testMethodReferences
	| methods |
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	methods := SmalltalkCI codeCoverageClass methodReferencesFor: { SCICodeCoverageTestTarget }.
	self assert: 2 equals: methods size.
	methods := SmalltalkCI codeCoverageClass methodReferencesFor: { SCICodeCoverageTestTarget class }.
	self assert: 4 equals: methods size