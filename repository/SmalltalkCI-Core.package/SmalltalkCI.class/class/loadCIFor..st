executing
loadCIFor: aFilenameString
  ^ self platformClass basicNew
    initialize;
    readSTONSpec: aFilenameString;
    loadCI