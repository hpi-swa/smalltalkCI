testing
testReportFailure
	| runner reporter stream |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.