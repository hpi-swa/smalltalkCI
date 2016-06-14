private
writeUnexpectedPassFailure
  suiteFailures := suiteFailures + 1.
  self stream
    tab;
    tab;
    nextPutAll:
        '<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>';
    lf
