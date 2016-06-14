executing
loadAndTest: aFilenameString produceXMLLog: aBool
  ^ self basicNew
    initialize;
    produceXMLLog: aBool;
    load;
    test