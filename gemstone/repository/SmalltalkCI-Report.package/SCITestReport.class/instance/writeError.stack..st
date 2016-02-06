private
writeError: error stack: stack
  suiteErrors := suiteErrors + 1.
  self produceXMLLog
    ifTrue: [ 
      self stream
        tab;
        tab;
        nextPutAll: '<error type="' ].
  self writeException: error stack: stack.
  self produceXMLLog
    ifTrue: [ 
      self stream
        nextPutAll: '</error>';
        lf ]