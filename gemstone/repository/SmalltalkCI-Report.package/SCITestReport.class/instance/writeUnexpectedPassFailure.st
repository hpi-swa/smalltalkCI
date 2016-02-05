private
writeUnexpectedPassFailure
  suiteFailures := suiteFailures + 1.
  progressFile
    nextPutAll: 'Test passed unexpectedly';
    cr