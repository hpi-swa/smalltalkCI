executing
report: aSCITestResult spec: aSCISpec
	SmalltalkCI forceNewFileNamed: (aSCITestResult suiteName , '.xml') do: [ :stream |
		self report: aSCITestResult spec: aSCISpec on: stream ]