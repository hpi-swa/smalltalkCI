testing
testRunClassesNamed
	| runner |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest} named: 'SmalltalkCITest'.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	self deny: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCI} named: 'SmalltalkCI'.
	self assert: 0 equals: runner totalTests.
	self deny: runner isSuccessful.