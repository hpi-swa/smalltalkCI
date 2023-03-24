executing
reportResults: aTestRunner
  GsFile gciLogServer: 'Reporting Results...'.
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
      GsFile gciLogServer: 'reporting results to ' , filePath printString.
      stream := GsFile openWriteOnServer: filePath.
      SCIGemStoneTestReporterFile report: aTestRunner spec: self spec on: stream.
      stream
        flush;
        close ].
  GsFile gciLogServer: 'Reporting Results... DONE'