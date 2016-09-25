testing
testReportFailure
	| runner reporter stream |
	runner := SCITestRunner runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	stream := WriteStream on: ''.
	reporter := SCITestReporterStdout report: runner on: stream.