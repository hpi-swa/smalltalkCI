reporting
reportResults: aTestRunner
	SCITestReporterStdout report: aTestRunner spec: self spec.
	SCITestReporterXML report: aTestRunner spec: self spec