executing
runTests
  testReport := SCITestReport
    runClasses: self classesToTest
    named: 'SmalltalkCI'
    produceXMLLog: self produceXMLLog