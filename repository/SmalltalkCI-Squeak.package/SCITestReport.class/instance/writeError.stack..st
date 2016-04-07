reporting
writeError: error stack: stack
	suiteErrors := suiteErrors + 1.
	self
		writeTab; writeTab;
		write: '<error type="';
		writeException: error stack: stack;
		write: '</error>';
		writeLf