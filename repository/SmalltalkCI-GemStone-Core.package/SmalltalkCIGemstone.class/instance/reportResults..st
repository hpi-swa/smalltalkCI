executing
reportResults: aTestRunner
  self reportFilePath
    ifNil: [ SCIGemStoneTestReporterStdout report: aTestRunner spec: self spec ]
    ifNotNil: [ :filePath | 
      | stream |
      stream := GsFile openWriteOnServer: filePath.
      GsFile stdout nextPutAll: '===== opened file ' , filePath printString.
      stream
        nextPutAll: '--- opened file';
        flush.
      SCIGemStoneTestReporterFile report: aTestRunner spec: self spec on: stream.
      stream
        flush;
        close ].
  produceXMLLog
    ifTrue: [ 
      SCIGemStoneTestReporterXML
        report: aTestRunner
        spec: self spec
        xmlLogDirPath: xmlLogDirPath ]
