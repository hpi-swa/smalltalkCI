running
tearDown
  suite resources do: [ :each | each reset ].
  self produceXMLLog
    ifTrue: [ 
      | xmlFilePath xmlFile |
      self stream
        tab;
        nextPutAll: '<system-out><![CDATA[]]></system-out>';
        lf;
        tab;
        nextPutAll: '<system-err><![CDATA[]]></system-err>';
        lf;
        nextPutAll: '</testsuite>';
        position: suitePosition;
        nextPutAll: ' failures="';
        print: suiteFailures;
        nextPutAll: '" errors="';
        print: suiteErrors;
        nextPutAll: '" time="';
        nextPutAll: ((self formatTime: suiteTime) printShowingDecimalPlaces: 3);
        nextPutAll: '">'.
      xmlFilePath := (System gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
        ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , '/' , suite name , '.xml' ]
        ifNil: [ suite name , '.xml' ].
      xmlFile := BinaryOrTextFile openWrite: xmlFilePath.
      xmlFile nextPutAll: stream contents.
      xmlFile xlose.
      stream := nil.
      progressFile
        cr;
        nextPutAll: self printString;
        cr;
        nextPutAll: 'finished running suite: ';
        nextPutAll: suite name ]
    ifFalse: [ 
      progressFile
        nextPutAll: '***********************************';
        cr;
        nextPutAll: ' failures=';
        nextPutAll: suiteFailures printString;
        nextPutAll: ' errors=';
        nextPutAll: suiteErrors printString;
        cr;
        nextPutAll: ' time=';
        nextPutAll: ((self formatTime: suiteTime) printShowingDecimalPlaces: 3);
        nextPutAll: ' seconds elapsed.';
        cr;
        nextPutAll: '***********************************';
        cr.
      self testCaseDefectsSummary: testCaseFailures label: 'Failures:'.
      self testCaseDefectsSummary: testCaseErrors label: 'Errors:'.
      self
        testCaseDefectsSummary: testCaseUnexpectedPasses
        label: 'UnexpectedPasses:'.
      progressFile
        nextPutAll: '***********************************';
        cr;
        nextPutAll: 'finished running suite: ';
        nextPutAll: suite name ]