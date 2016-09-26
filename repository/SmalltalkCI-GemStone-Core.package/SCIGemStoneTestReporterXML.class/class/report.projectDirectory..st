executing
report: aSCITestRunner projectDirectory: xmlFile
	self
		basicNew
		runner: aSCITestRunner;
		initialize;
		report;
		writeToFile
	