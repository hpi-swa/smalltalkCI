executing
report: aSCITestRunner spec: aSCISpec
	SmalltalkCI forceNewFileNamed: (aSCITestRunner suiteName , '.xml') do: [ :stream |
		self report: aSCITestRunner spec: aSCISpec on: stream ]