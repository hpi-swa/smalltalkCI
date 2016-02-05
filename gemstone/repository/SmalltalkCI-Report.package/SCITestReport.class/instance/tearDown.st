running
tearDown
  suite resources do: [ :each | each reset ].
  progressFile
    nextPutAll: ' failures=';
    nextPutAll: suiteFailures printString;
    nextPutAll: ' errors=';
    nextPutAll: suiteErrors printString;
    cr;
    nextPutAll: ' time=';
    nextPutAll: ((self formatTime: suiteTime) printShowingDecimalPlaces: 2);
    nextPutAll: ' seconds elapsed.';
    cr;
    nextPutAll: 'finished running suite: ';
    nextPutAll: suite name