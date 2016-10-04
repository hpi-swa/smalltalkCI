executing
reportResults: aTestRunner
	SCIGemStoneTestReporterStdout report: aTestRunner.
	produceXMLLog ifTrue: [
		SCIGemStoneTestReporterXML report: aTestRunner xmlLogDirPath: xmlLogDirPath ]