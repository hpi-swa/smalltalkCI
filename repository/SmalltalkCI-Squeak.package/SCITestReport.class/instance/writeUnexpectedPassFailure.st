reporting
writeUnexpectedPassFailure
	suiteFailures := suiteFailures + 1.
	self
		writeTab; writeTab;
		write: '<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>';
		writeLf