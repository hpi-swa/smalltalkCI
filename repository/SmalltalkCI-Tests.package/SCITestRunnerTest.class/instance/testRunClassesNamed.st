testing
testRunClassesNamed
	| runner |
	runner := SCITestRunner runClasses: {SmalltalkCITest} named: 'SmalltalkCI'.
	self assert: runner isSuccessful.
	runner := SCITestRunner runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	self deny: runner isSuccessful