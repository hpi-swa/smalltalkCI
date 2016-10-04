executing
loadAndTest: aFilenameString env: buildEnvironment
  BuildEnvironment := buildEnvironment.
  ^ self basicNew
    initialize;
    load;
    test