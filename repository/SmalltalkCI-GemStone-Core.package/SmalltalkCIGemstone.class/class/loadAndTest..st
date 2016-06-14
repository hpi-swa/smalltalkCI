executing
loadAndTest: aFilenameString
  ^ self basicNew
    initialize;
    load;
    test