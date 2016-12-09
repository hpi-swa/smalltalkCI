testing
testReportFailure
	| runner reporter stream result |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SCIExcludedTests'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	self assert: self class failureFixture matches: result
