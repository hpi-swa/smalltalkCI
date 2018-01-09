public-api
loadAndTest: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    load;
    test