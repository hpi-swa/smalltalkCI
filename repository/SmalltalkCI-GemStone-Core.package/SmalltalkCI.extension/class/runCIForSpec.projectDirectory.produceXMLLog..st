*SmalltalkCI-Gemstone-Core
runCIForSpec: aSmalltalkCISpec projectDirectory: aDirectoryPathString produceXMLLog: aBool
  ^ self platformClass basicNew
    initialize;
    spec: aSmalltalkCISpec;
    projectDirectory: aDirectoryPathString;
    produceXMLLog: aBool;
    runCI