*SmalltalkCI-Gemstone-Core
runCIFor: aFilenameString xmlLogDirPath: aString
  ^ self platformClass basicNew
    initialize;
    produceXMLLog: true;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    test