testing
testReportFailure
	| runner reporter stream |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	stream := WriteStream on: ''.
	reporter := SCITestReporterStdout report: runner on: stream.