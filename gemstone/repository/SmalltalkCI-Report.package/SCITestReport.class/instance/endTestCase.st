private
endTestCase
  progressFile
    nextPutAll: 'finished';
    cr.
  self produceXMLLog
    ifTrue: [ 
      self stream
        tab;
        nextPutAll: '</testcase>';
        lf ]