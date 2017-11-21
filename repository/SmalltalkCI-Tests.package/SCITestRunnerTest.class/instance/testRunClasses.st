testing
testRunClasses
	| runner |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest}.
	self assert: runner isSuccessful.
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests}.
	self deny: runner isSuccessful.
	self
		should: [ SmalltalkCI testRunnerClass runClasses: {SmalltalkCI} ]
		raise: SCIError