as yet unclassified
testAdjustDefaultTimeoutIfRequested
	| sci originalValue originalSource |
	sci := SmalltalkCI newInstance.
	sci spec: (SmalltalkCISpec new testing: (
		Dictionary new
			add: #'defaultTimeout' -> 60;
			yourself)).
	originalValue := TestCase new defaultTimeout.
	originalSource := (TestCase methodDict at: #defaultTimeout) getSource.
	[
		sci adjustDefaultTimeoutIfRequested.
		self assert: (TestCase new defaultTimeout) equals: 60
			] ensure: [
				TestCase compile: originalSource.
				self assert: (TestCase new defaultTimeout) equals: originalValue ]