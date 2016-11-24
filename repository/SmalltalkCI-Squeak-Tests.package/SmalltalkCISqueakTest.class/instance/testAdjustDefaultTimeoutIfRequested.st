testing
testAdjustDefaultTimeoutIfRequested
	| sci originalValue originalMethod originalTestMethod |
	sci := SmalltalkCI newInstance.
	sci spec: (SmalltalkCISpec new testing: (
		Dictionary new
			add: #'defaultTimeout' -> 60;
			yourself)).
	originalValue := TestCase new defaultTimeout.
	originalMethod := (TestCase methodDict at: #defaultTimeout).
	originalTestMethod := (SUnitTest methodDict at: #testTestTimeout).
	[ | newTestMethod |
		sci adjustDefaultTimeoutIfRequested.
		self assert: (TestCase new defaultTimeout) equals: 60.
		newTestMethod := (SUnitTest methodDict at: #testTestTimeout).
		self assert: originalTestMethod getSource ~= newTestMethod getSource.
			] ensure: [
				TestCase addSelector: #defaultTimeout withMethod: originalMethod notifying: nil.
				SUnitTest addSelector: #testTestTimeout withMethod: originalTestMethod notifying: nil.
				self assert: (TestCase new defaultTimeout) equals: originalValue ]