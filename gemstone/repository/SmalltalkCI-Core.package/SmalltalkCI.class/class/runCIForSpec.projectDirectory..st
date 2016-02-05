executing
runCIForSpec: aSmalltalkCISpec projectDirectory: aDirectoryPathString
  ^ self platformClass basicNew
    initialize;
    spec: aSmalltalkCISpec;
    projectDirectory: aDirectoryPathString;
    runCI