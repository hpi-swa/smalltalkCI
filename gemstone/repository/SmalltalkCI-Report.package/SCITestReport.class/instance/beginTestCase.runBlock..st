private
beginTestCase: aTestCase runBlock: aBlock
  | time |
  progressFile
    nextPutAll: 'starting testcase: ';
    nextPutAll: aTestCase class name;
    nextPutAll: '>>';
    nextPutAll: aTestCase selector;
    nextPutAll: ' ... '.
  time := self formatTime: aBlock timeToRun.
  progressFile
    nextPutAll: '" time="';
    nextPutAll: (time printShowingDecimalPlaces: 3);
    nextPutAll: ' ... '