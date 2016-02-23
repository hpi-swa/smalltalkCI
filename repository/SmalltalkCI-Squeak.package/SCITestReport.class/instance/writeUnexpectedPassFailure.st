private
writeUnexpectedPassFailure
  suiteFailures := suiteFailures + 1.
  stream tab; tab;
	nextPutAll: '<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>'; lf