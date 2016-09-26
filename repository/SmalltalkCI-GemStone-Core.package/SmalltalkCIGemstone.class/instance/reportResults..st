executing
reportResults: aTestRunner
	SCITestReporterStdout report: aTestRunner.
	SCIGemStoneTestReporterXML report: aTestRunner projectDirectory: self projectDirectory