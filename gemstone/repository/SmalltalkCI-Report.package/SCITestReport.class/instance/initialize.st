initialization
initialize
  super initialize.
  suiteTime := 0 asDuration.
  suitePosition := suiteFailures := suiteErrors := 0.
  testCaseFailures := OrderedCollection new.
  testCaseErrors := OrderedCollection new.
  testCaseUnexpectedPasses := OrderedCollection new