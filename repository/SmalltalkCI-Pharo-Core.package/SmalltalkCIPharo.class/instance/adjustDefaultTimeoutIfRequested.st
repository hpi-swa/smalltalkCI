private
adjustDefaultTimeoutIfRequested
	self spec testing at: #defaultTimeout ifPresent: [ :seconds |
		(TestCase respondsTo: #defaultTimeLimitSecs:) ifTrue: [
			TestCase defaultTimeLimitSecs: seconds.
			SmalltalkCI printToStdout: 'defaultTimeLimitSecs set to ', seconds asString ]]