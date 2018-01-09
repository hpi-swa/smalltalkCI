testing
testRunSpecNamed
	| runner |
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCITest).
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SCIExcludedTests).
	self deny: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCI).
	self assert: 0 equals: runner totalTests.
	self assert: runner isSuccessful.