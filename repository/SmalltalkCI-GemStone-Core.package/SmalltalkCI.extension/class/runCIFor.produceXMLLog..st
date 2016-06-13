*SmalltalkCI-Gemstone-Core
runCIFor: aFilenameString produceXMLLog: aBool
  ^ self platformClass basicNew
    initialize;
    produceXMLLog: aBool;
    runCIFor: aFilenameString