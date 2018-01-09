public-api
loadAndTest: aFilenameString produceXMLLog: produceXMLLog
  ^ self basicNew
    initialize;
    spec: (SmalltalkCISpec fromFile: aFilenameString);
    produceXMLLog: produceXMLLog
    load;
    test