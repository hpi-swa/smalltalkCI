executing
reportResults: aTestRunner
	SCIGemStoneTestReporterStdout report: aTestRunner.
	self produceXMLLog ifTrue: [
		SCIGemStoneTestReporterXML report: aTestRunner xmlLogDirPath: xmlLogDirPath ]