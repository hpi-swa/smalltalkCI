executing
reportResults: aTestRunner
	SCITestReporterStdout report: aTestRunner spec: self spec.
	SCITestReporterXML report: aTestRunner