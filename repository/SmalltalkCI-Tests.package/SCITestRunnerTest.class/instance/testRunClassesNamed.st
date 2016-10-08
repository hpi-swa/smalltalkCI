testing
testRunClassesNamed
	| runner |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest} named: 'SmalltalkCI'.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	self deny: runner isSuccessful