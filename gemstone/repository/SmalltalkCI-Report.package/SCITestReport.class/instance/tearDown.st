running
tearDown
  suite resources do: [ :each | each reset ].
  self produceXMLLog
    ifTrue: [ 
      | xmlFilePath xmlFile |
      stream
        tab;
        nextPutAll: '<system-out><![CDATA[]]></system-out>';
        lf.
      stream
        tab;
        nextPutAll: '<system-err><![CDATA[]]></system-err>';
        lf.
      stream nextPutAll: '</testsuite>'.
      stream position: suitePosition.
      stream
        nextPutAll: ' failures="';
        print: suiteFailures;
        nextPutAll: '" errors="';
        print: suiteErrors;
        nextPutAll: '" time="';
        nextPutAll: ((self formatTime: suiteTime) printShowingDecimalPlaces: 3);
        nextPutAll: '">'.
      stream close.
      progressFile
        nextPutAll: self printString;
        cr;
        nextPutAll: 'finished running suite: ';
        nextPutAll: suite name ]
    ifFalse: [ 
      progressFile
        nextPutAll: ' failures=';
        nextPutAll: suiteFailures printString;
        nextPutAll: ' errors=';
        nextPutAll: suiteErrors printString;
        cr;
        nextPutAll: ' time=';
        nextPutAll: ((self formatTime: suiteTime) printShowingDecimalPlaces: 3);
        nextPutAll: ' seconds elapsed.';
        cr;
        nextPutAll: 'finished running suite: ';
        nextPutAll: suite name ]