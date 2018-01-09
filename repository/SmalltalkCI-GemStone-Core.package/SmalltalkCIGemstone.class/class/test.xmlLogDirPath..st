public-api
test: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    test