public-api
test: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    test