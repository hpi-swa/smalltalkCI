executing
runTests
  testReport := SCITestReport
    runClasses: self classesToTest
    named: self spec specName , '_GemStone'
    produceXMLLog: self produceXMLLog