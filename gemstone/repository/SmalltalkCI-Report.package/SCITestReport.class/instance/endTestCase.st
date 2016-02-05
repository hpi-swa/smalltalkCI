private
endTestCase
  progressFile
    nextPutAll: 'finished';
    cr.
  self produceXMLLog
    ifTrue: [ 
      stream
        tab;
        nextPutAll: '</testcase>';
        lf ]