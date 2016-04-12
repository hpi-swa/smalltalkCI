executing
runCIFor: aFilenameString projectDirectory: aDirectoryPathString
  ^ self platformClass basicNew
    initialize;
    reportImage;
    readSTONSpec: aFilenameString;
    projectDirectory: aDirectoryPathString;
    runCI