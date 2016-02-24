running
runSuite: aTestSuite produceXMLLog: produceXMLLog
  ^ self new
    produceXMLLog: produceXMLLog;
    initializeOn: aTestSuite;
    run