executing
reportResults: aTestRunner
  self reportFilePath
    ifNil: [ SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec ]
    ifNotNil: [ :filePath | 
      | stream |
      stream := GsFile openWriteOnServer: filePath.
      SCIGemStoneTestReporterFile report: aTestRunner spec: self spec on: stream.
      stream
        flush;
        close ].
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
        close ]