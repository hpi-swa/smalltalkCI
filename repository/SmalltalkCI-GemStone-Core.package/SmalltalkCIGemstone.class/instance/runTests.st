executing
runTests
	testReport := SCIGemStoneTestReport
		runClasses: self classesToTest
		named: self suiteName
		xmlLogDirPath: self xmlLogDirPath