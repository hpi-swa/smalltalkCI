executing
report: aSCITestRunner projectDirectory: projectDirectory
	self
		basicNew
		runner: aSCITestRunner;
		projectDirectory: projectDirectory
		initialize;
		report;
		writeToFile
	