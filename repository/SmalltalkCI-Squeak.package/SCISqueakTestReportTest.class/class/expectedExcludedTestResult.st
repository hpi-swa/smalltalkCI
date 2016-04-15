as yet unclassified
expectedExcludedTestResult
	^ '<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="excluded_tests" tests="5" failures="2" errors="1" time="0.0">                                                                 
	<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testError" time="0.0">
		<error type="Error" message="An error message.">SCIExcludedTests(Object)>>error:
SCIExcludedTests>>testError
SCIExcludedTests(TestCase)>>performTest
</error>
	</testcase>
	<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testFailure" time="0.0">
		<failure type="TestFailure" message="A failure message.">SCIExcludedTests(TestCase)>>assert:description:
SCIExcludedTests(TestCase)>>fail:
SCIExcludedTests>>testFailure
SCIExcludedTests(TestCase)>>performTest
</failure>
	</testcase>
	<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testShouldFail" time="0.0">
	</testcase>
	<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testShouldPass" time="0.0">
	</testcase>
	<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testShouldPassUnexpectedly" time="0.0">
		<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>
	</testcase>
	<system-out><![CDATA[]]></system-out>
	<system-err><![CDATA[]]></system-err>
</testsuite>'