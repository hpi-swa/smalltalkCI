printing
printOn: aStream
  aStream
    nextPutAll:
        '###########################################################################';
    cr;
    nextPutAll: '# ' , suite name , ': ';
    nextPutAll: self suiteTotal printString , ' Tests, ';
    nextPutAll: self suiteFailures printString , ' Failures, ';
    nextPutAll: self suiteErrors printString , ' Errors in ';
    nextPutAll:
        ((self formatTime: suiteTime) printShowingDecimalPlaces: 3) , 's';
    cr;
    nextPutAll:
        '###########################################################################';
    yourself