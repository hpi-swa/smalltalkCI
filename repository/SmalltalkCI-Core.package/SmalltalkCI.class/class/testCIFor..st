executing
testCIFor: aFilenameString
  ^ self platformClass basicNew
    initialize;
    readSTONSpec: aFilenameString;
    testCI