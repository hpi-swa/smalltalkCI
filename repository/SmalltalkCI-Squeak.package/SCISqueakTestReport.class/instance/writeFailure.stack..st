reporting
writeFailure: error stack: stack
	suiteFailures := suiteFailures + 1.
	self
		writeTab; writeTab;
		write: '<failure type="';
		writeException: error stack: stack;
		write: '</failure>';
		writeLf