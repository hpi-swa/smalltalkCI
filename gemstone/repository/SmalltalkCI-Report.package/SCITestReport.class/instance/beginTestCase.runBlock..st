private
beginTestCase: aTestCase runBlock: aBlock
  progressFile
    nextPutAll: 'starting testcase: ';
    nextPutAll: aTestCase class name;
    nextPutAll: '>>';
    nextPutAll: aTestCase selector;
    nextPutAll: ' ... '