executing
reportResults: aTestRunner
	SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec.
	produceXMLLog ifTrue: [
		SCIGemStoneTestReporterXML report: aTestRunner spec: self spec xmlLogDirPath: xmlLogDirPath ]