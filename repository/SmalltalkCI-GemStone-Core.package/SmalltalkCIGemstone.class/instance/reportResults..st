executing
reportResults: aTestRunner
	SCIGemStoneTestReporterStdout report: aTestRunner.
	SCIGemStoneTestReporterXML report: aTestRunner xmlLogDirPath: self xmlLogDirPath