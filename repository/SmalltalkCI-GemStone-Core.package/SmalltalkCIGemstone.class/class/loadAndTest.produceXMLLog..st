public-api
loadAndTest: aFilenameString produceXMLLog: produceXMLLog
  ^ self basicNew
    initialize;
    readSTONSpec: aFilenameString;
    produceXMLLog: produceXMLLog
    load;
    test