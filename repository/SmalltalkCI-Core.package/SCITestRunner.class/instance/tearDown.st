running
tearDown
	suite resources
		do: [ :each | each reset ].

	Transcript cr; show: 'Finished running suite: ', suite name; cr.
	SCITestReporterStdout report: self.
	SCITestReporterXML report: self