private
writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  self writeException: error stack: stack