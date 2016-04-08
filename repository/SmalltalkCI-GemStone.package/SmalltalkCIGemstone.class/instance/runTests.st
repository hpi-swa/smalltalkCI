executing
runTests
  testReport := SCITestReport
    runClasses: self classesToTest
    named: self suiteName
    produceXMLLog: self produceXMLLog