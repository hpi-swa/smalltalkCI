testing
testReport
	| runner reporter stream |
	runner := SCITestRunner runClasses: {SmalltalkCITest} named: 'SmalltalkCI'.
	stream := WriteStream on: ''.
	reporter := SCITestReporterStdout report: runner on: stream.
	runner := SCITestRunner runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	self deny: runner isSuccessful