executing
test: aFilenameString env: buildEnvironment xmlLogDirPath: aString
  BuildEnvironment := buildEnvironment.
  ^ self basicNew
    initialize;
    xmlLogDirPath: aString;
    readSTONSpec: aFilenameString;
    test