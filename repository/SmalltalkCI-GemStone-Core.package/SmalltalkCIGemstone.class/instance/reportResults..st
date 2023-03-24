executing
reportResults: aTestRunner
  SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec.
  produceXMLLog
    ifTrue: [ 
      SCIGemStoneTestReporterXML
        report: aTestRunner
        spec: self spec
        xmlLogDirPath: xmlLogDirPath ].
  self reportFilePath
    ifNotNil: [ :filePath | 
      | stream |
      stream := GsFile openWriteOnServer: filePath.
      SCIGemStoneTestReporterStdout
        report: aTestRunner
        spec: self spec
        on: stream.
      stream
        flush;
        close ]