running
runSuite: aTestSuite xmlLogDirPath: aDirectoryPath
  ^ self new
    xmlLogDirPath: aDirectoryPath;
    initializeOn: aTestSuite;
    run