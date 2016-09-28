executing
reportResults: aTestRunner
	SCIGemStoneTestReporterStdout report: aTestRunner.
	SCIGemStoneTestReporterXML report: aTestRunner projectDirectory: self projectDirectory