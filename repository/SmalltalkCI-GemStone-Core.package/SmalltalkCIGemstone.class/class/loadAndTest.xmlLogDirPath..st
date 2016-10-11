public-api
loadAndTest: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    load;
    test