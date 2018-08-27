testing
testRunClasses
	| result |
	result := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest}.
	self assert: result successful.
	result := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests}.
	self deny: result successful.
	self
		should: [ SmalltalkCI testRunnerClass runClasses: {SmalltalkCI} ]
		raise: SCIError