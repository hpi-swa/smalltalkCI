testing
testReportFailure
	| result reporter stream resultString expectedTests index |
	result := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			named: 'XML-testReportFailure'
			forClass: SCIExcludedTests).
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterXML report: result on: stream.
	resultString := stream contents.
	expectedTests := SmalltalkCITest expectedTests: SCIExcludedTests.
	"Check content and respect order"
	index := resultString findString: '<?xml version="1.0" encoding="UTF-8"?>'.
	self assert: index = 1.
	index := resultString findString: '<testsuite name="XML-testReportFailure"' startingAt: index.
	self assert: index > 0.
	index := resultString findString: 'tests="', expectedTests size asString, '"' startingAt: index.
	self assert: index > 0.
	index := resultString findString: 'failures="', result failedTests asString ,'"' startingAt: index.
	self assert: index > 0.
	index := resultString findString: 'errors="', result erroredTests asString ,'"' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '<testcase classname="SmalltalkCI.Excluded.Tests' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '<failure type="TestFailure"' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '</failure>' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '<system-out><![CDATA[]]></system-out>' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '<system-err><![CDATA[]]></system-err>' startingAt: index.
	self assert: index > 0.
	index := resultString findString: '</testsuite>' startingAt: index.
	self assert: index > 0
