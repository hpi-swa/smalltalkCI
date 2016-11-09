private
adjustDefaultTimeoutIfRequested
	self spec testing at: #defaultTimeout ifPresent: [ :seconds |
		TestCase compile: 'defaultTimeout ^ ', seconds ]