running
runSuite: aTestSuite produceXMLLog: produceXMLLog xmlLogDirPath: aDirectoryPath
  ^ self new
    produceXMLLog: produceXMLLog;
    xmlLogDirPath: aDirectoryPath;
    initializeOn: aTestSuite;
    run