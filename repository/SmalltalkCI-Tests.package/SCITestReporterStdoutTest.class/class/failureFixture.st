fixtures
failureFixture
	^ '
[1m[34m###############
[1m[34m# SCIExcludedTests#
[1m[34m# 6 Tests with 3 Failures and 1 Errors in s #
[1m[34m###############
[0m
(2 tests passed)
[1m
SCIExcludedTests
[0m[32m ✓[0m SCIExcludedTests>>#testShouldFail (ms)[0m
[32m ✓[0m SCIExcludedTests>>#testShouldPass (ms)[0m

[1m[31m#########################
[1m[31m# 4 tests did not pass: #
[1m[31m#########################
[0m[1m
SCIExcludedTests
[0m[1m[33m ✗ SCIExcludedTests>>#testAssertError (ms)[0m
[0m[1m[31m ✗ SCIExcludedTests>>#testError (ms)[0m
[0m[1m[33m ✗ SCIExcludedTests>>#testFailure (ms)[0m
[0m[1m[33m ✗ SCIExcludedTests>>#testShouldPassUnexpectedly (ms)[0m

[1m[31m###########
[1m[31m# Summary #
[1m[31m###########
[0m[1m
SCIExcludedTests
[0m[33m ✗ SCIExcludedTests>>#testAssertError (ms)[0m
[31m ✗ SCIExcludedTests>>#testError (ms)[0m
[33m ✗ SCIExcludedTests>>#testFailure (ms)[0m
[33m ✗ SCIExcludedTests>>#testShouldPassUnexpectedly (ms)[0m


[1m[31m  Executed 6 Tests with 3 Failures and 1 Errors in s.[0m

'