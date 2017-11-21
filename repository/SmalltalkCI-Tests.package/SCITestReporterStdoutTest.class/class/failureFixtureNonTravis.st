fixtures
failureFixtureNonTravis
	^ '
[1m[34m###############
[1m[34m# Stdout-testReportFailure#
[1m[34m# 8 Tests with 4 Failures and 1 Errors in s #
[1m[34m###############
[0m
(3 tests passed)
[1m
SCIExcludedTests
[0m[32m ✓[0m #testDeprecation (ms)[0m
[32m ✓[0m #testShouldFail (ms)[0m
[32m ✓[0m #testShouldPass (ms)[0m

[1m[31m#########################
[1m[31m# 5 tests did not pass: #
[1m[31m#########################
[0m[1m
SCIExcludedTests
[0m[1m[33m ✗ #testAssertError (ms)[0m
[0m[1m[31m ✗ #testError (ms)[0m
[0m[1m[33m ✗ #testFailure (ms)[0m
[0m[1m[33m ✗ #testShouldPassUnexpectedly (ms)[0m
[0m[1m[33m ✗ #testThisIsAVeryLongMethodNameThat...playedCorrectlyInATravisLog (ms)[0m

[1m[31m###########
[1m[31m# Summary #
[1m[31m###########
[0m[1m
SCIExcludedTests
[0m[33m ✗ #testAssertError (ms)[0m
[31m ✗ #testError (ms)[0m
[33m ✗ #testFailure (ms)[0m
[33m ✗ #testShouldPassUnexpectedly (ms)[0m
[33m ✗ #testThisIsAVeryLongMethodNameThatProbablyNeedsToBeContractedInOrderToBeDisplayedCorrectlyInATravisLog (ms)[0m
[1m[31msmalltalkCI Deprecation Warnings[0m
 - SCIExcludedTests>>testDeprecation (This is just a test)


[1m[31m  Executed 8 Tests with 4 Failures and 1 Errors in s.[0m

'