executing
testCIFor: aFilenameString named: aString
  ^ self platformClass basicNew
    initialize;
    readSTONSpec: aFilenameString;
    suiteName: aString;
    testCI