testing
testRunSpecNamed
	| runner |
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCITest)
		named: 'testRunSpecNamed: SmalltalkCITest'.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SCIExcludedTests)
		named: 'testRunSpecNamed: SmalltalkCI-Excluded'.
	self deny: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SmalltalkCI)
		named: 'testRunSpecNamed: SmalltalkCI'.
	self assert: 0 equals: runner totalTests.
	self deny: runner isSuccessful.