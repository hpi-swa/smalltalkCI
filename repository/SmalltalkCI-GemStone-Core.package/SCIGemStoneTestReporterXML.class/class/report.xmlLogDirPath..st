executing
report: aSCITestRunner xmlLogDirPath: xmlLogDirPath
	self
		basicNew
		runner: aSCITestRunner;
		xmlLogDirPath: xmlLogDirPath;
		initialize;
		report;
		writeToFile
	