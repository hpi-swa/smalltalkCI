private
writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  self produceXMLLog
    ifTrue: [ 
      self stream
        tab;
        tab;
        nextPutAll: '<failure type="' ].
  self writeException: error stack: stack.
  self produceXMLLog
    ifTrue: [ 
      self stream
        nextPutAll: '</failure>';
        lf ]