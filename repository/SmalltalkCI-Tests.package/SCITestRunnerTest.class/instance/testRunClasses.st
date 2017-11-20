testing
testRunClasses
	| runner |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest}.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests}.
	self deny: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCI}.
	self assert: 0 equals: runner totalTests.
	self deny: runner isSuccessful.