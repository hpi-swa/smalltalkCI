testing
testReportFailure
	| warnings result reporter stream resultString |
	warnings := SmalltalkCI deprecationWarnings.
	[ SmalltalkCI deprecatedReset.
	result := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			named: 'Stdout-testReportFailure'
			forClass: SCIExcludedTests).
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: result on: stream.
	resultString := stream contents.
	self assert: self class failureFixture matches: resultString ]
		ensure: [ SmalltalkCI deprecationWarnings: warnings ]
