executing
loadAndTest: aFilenameString xmlLogDirPath: aString
  ^ self basicNew
    initialize;
    produceXMLLog: true;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    load;
    test