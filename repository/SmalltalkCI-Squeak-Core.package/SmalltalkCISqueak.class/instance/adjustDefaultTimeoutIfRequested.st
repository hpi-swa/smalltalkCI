private
adjustDefaultTimeoutIfRequested
	self spec testing at: #defaultTimeout ifPresent: [ :seconds |
		"Patch TestCase>>defaultTimeout and corresponding SUnit test case"
		TestCase compile: 'defaultTimeout ^ ', seconds.
		SUnitTest compile: 'testTestTimeout self should:[(Delay forSeconds: ', (seconds + 2) ,') wait] raise: TestFailure.' ]