testing
testReportFailure
	| warnings runner reporter stream result |
	warnings := SmalltalkCI deprecationWarnings.
	[ SmalltalkCI deprecatedReset.
	runner := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			forClass: SCIExcludedTests 
			withSuiteName: 'Stdout-testReportFailure').
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	self assert: self class failureFixture matches: result ]
		ensure: [ SmalltalkCI deprecationWarnings: warnings ]
