executing-deprecated
loadAndTest: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    load;
    test