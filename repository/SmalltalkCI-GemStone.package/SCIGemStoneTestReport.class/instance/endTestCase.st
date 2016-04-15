private
endTestCase
  self produceXMLLog
    ifTrue: [ 
      progressFile nextPutAll: '>'.
      self stream
        tab;
        nextPutAll: '</testcase>';
        lf ]
    ifFalse: [ 
      progressFile
        nextPutAll: 'finished';
        cr ]