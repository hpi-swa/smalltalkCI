executing
runTests
  testReport := SCITestReport
    runClasses: self classesToTest
    named: self spec specName
    produceXMLLog: self produceXMLLog