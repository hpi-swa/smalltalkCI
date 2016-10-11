executing
report: aSCITestRunner on: aStream
	self
		basicNew
		runner: aSCITestRunner;
		initialize;
		stream: aStream;
		report