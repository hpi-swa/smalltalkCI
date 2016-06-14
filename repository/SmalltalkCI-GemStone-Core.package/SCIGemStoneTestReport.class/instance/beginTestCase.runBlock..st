private
beginTestCase: aTestCase runBlock: aBlock
  | time |
  time := self formatTime: aBlock timeToRun.
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
    lf