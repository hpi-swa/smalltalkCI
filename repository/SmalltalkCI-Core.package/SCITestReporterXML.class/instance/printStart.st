printing
printStart
	self
		print: '<?xml version="1.0" encoding="UTF-8"?>'; newLine;
		print: '<testsuite name="', (self encode: result suiteName);
    		print: '" tests="', result totalTests asString;
    		print: '" failures="', result failedTests asString;
    		print: '" errors="', result erroredTests asString;
    		print: '" time="', (result suiteTime / 1000.0) asString , '">';
		newLine