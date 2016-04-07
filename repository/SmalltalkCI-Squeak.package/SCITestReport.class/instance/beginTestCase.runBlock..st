private
beginTestCase: aTestCase runBlock: aBlock
  | time |
  progressFile nextPut: $-; flush.

  time := self formatTime: (aBlock timeToRun).

  stream tab;
    nextPutAll: '<testcase classname="';
    nextPutAll: (self encode: (aTestCase class category copyReplaceAll: '-' with: '.'));
    nextPut: $.; nextPutAll: (self encode: aTestCase class name);
    nextPutAll: '" name="'; nextPutAll: (self encode: aTestCase selector);
    nextPutAll: '" time="'; print: time;
    nextPutAll: '">'; lf

