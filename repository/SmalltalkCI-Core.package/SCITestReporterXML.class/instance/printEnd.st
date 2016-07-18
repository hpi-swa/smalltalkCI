printing
printEnd
	self
		tab;
		print: '<system-out><![CDATA[]]></system-out>'; lf;
		tab; print: '<system-err><![CDATA[]]></system-err>'; lf;
		print: '</testsuite>'.