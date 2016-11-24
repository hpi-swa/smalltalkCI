testing
testReportFailure
	| runner reporter stream result expectedTests index |
	runner := SmalltalkCI testRunnerClass runClasses: {SCIExcludedTests} named: 'SmalltalkCI-Excluded'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SCIExcludedTests.
	"Check content and respect order"
	index := result findString: '##############'.
	self assert: index > 0.
	index := result findString: SmalltalkCI ansiBold, SmalltalkCI ansiBlue startingAt: index.
	self assert: index > 0.
	index := result findString: 'SmalltalkCI-Excluded' startingAt: index.
	self assert: index > 0.
	index := result findString: expectedTests size asString, ' Tests' startingAt: index.
	self assert: index > 0.
	index := result findString: runner failedTests asString, ' Failures and' startingAt: index.
	self assert: index > 0.
	index := result findString: runner erroredTests asString, ' Errors' startingAt: index.
	self assert: index > 0.
	index := result findString: '(', runner passingTests asString ,' tests passed)' startingAt: index.
	self assert: index > 0.
	index := result findString: (runner failedTests + runner erroredTests) asString ,' tests did not pass' startingAt: index.
	self assert: index > 0.
	index := result findString: SmalltalkCI ansiBold, SmalltalkCI ansiRed startingAt: index.
	self assert: index > 0.
