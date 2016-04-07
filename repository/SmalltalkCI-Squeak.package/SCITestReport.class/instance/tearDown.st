running
tearDown
	suite resources
		do: [ :each | each reset ].

	self
		writeTab;
		write: '<system-out><![CDATA[]]></system-out>'; writeLf;
		writeTab; write: '<system-err><![CDATA[]]></system-err>'; writeLf;
		write: '</testsuite>'.

	stream position: suitePosition.
	self 
		write: ' failures="', suiteFailures, '" ';
		write: 'errors="', suiteErrors, '" ';
		write: 'time="', (self formatTime: suiteTime), '">'.
	stream close.

	self logCr; log: 'Finished running suite: ', suite name