printing
printStart
	self
		print: '<?xml version="1.0" encoding="UTF-8"?>'; newLine;
		print: '<testsuite name="', (self encode: runner suiteName);
    		print: '" tests="', runner totalTests asString;
    		print: '" failures="', runner failedTests asString;
    		print: '" errors="', runner erroredTests asString;
    		print: '" time="', (runner suiteTime / 1000.0) asString , '">';
		newLine
