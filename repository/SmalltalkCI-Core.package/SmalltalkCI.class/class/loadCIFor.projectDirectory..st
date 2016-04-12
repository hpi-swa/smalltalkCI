executing
loadCIFor: aFilenameString projectDirectory: aDirectoryPathString
  ^ self platformClass basicNew
    initialize;
    readSTONSpec: aFilenameString;
    projectDirectory: aDirectoryPathString;
    loadCI