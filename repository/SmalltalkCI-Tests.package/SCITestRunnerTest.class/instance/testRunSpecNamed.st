testing
testRunSpecNamed
	| result |
	result := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCITest).
	self assert: result successful.
	result := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SCIExcludedTests).
	self deny: result successful.
	result := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCI).
	self assert: 0 equals: result totalTests.
	self assert: result successful.