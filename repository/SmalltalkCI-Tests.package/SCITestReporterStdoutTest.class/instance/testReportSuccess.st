testing
testReportSuccess
	| runner reporter stream result |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIPassingTests} named: 'MyRunnerName'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	self assert: self class successFixture matchesLines: result