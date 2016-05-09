constants
expectedSubStrings
	^ #('<?xml version="1.0" encoding="UTF-8"?>'
		'testsuite name="__excluded_tests" tests="6" failures="3" errors="1"'
		'<error type="Error" message="An error message.">SCIExcludedTests(Object)>>error:'
		'<failure type="TestFailure" message="A failure message.">SCIExcludedTests(TestCase)>>assert:description:'
		'<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testShouldFail"'
		'<testcase classname="SmalltalkCI.Excluded.Tests.SCIExcludedTests" name="testShouldPass"'
		'<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>')