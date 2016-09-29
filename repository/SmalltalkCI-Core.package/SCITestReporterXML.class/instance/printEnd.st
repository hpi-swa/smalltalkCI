printing
printEnd
	self
		tab;
		print: '<system-out><![CDATA[]]></system-out>'; newLine;
		tab; print: '<system-err><![CDATA[]]></system-err>'; newLine;
		print: '</testsuite>'.