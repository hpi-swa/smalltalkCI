*SmalltalkCI-Gemstone-Core
runCIFor: aFilenameString xmlLogDirPath: aString
  ^ self platformClass basicNew
    initialize;
    produceXMLLog: true;
    xmlLogDirPath: aString;
    runCIFor: aFilenameString