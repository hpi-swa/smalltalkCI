executing
loadAndTest: aFilenameString env: buildEnvironment xmlLogDirPath: aString
  BuildEnvironment := buildEnvironment.
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    load;
    test