private
beginTestCase: aTestCase runBlock: aBlock
  | time |
  self produceXMLLog
    ifTrue: [ progressFile nextPutAll: '-' ]
    ifFalse: [ 
      progressFile
        nextPutAll: 'starting testcase: ';
        nextPutAll: aTestCase class name;
        nextPutAll: '>>';
        nextPutAll: aTestCase selector;
        nextPutAll: ' ... ' ].
  time := self formatTime: aBlock timeToRun.
  self produceXMLLog
    ifTrue: [ 
      self stream
        tab;
        nextPutAll: '<testcase classname="';
        nextPutAll:
            (self encode: (aTestCase class category copyReplaceAll: '-' with: '.'));
        nextPut: $.;
        nextPutAll: (self encode: aTestCase class name);
        nextPutAll: '" name="';
        nextPutAll: (self encode: aTestCase selector);
        nextPutAll: '" time="';
        nextPutAll: (time printShowingDecimalPlaces: 3);
        nextPutAll: '">';
        lf ]
    ifFalse: [ 
      progressFile
        nextPutAll: '" time="';
        nextPutAll: (time printShowingDecimalPlaces: 3);
        nextPutAll: ' ... ' ]