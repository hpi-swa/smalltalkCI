executing
runTests
  testReport := SCITestReport
    runClasses: self classesToTest
    named: self suiteName
    xmlLogDirPath: self xmlLogDirPath