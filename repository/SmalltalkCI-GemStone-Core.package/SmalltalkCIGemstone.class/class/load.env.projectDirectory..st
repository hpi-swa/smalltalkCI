executing
load: aFilenameString env: buildEnvironment projectDirectory: aDirectoryPathString
  BuildEnvironment := buildEnvironment.
  ^ self basicNew
    initialize;
    readSTONSpec: aFilenameString;
    projectDirectory: aDirectoryPathString;
    load