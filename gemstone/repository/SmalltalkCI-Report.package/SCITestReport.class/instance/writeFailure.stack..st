private
writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  self produceXMLLog
    ifTrue: [ 
      stream
        tab;
        tab;
        nextPutAll: '<failure type="' ].
  self writeException: error stack: stack.
  self produceXMLLog
    ifTrue: [ 
      stream
        nextPutAll: '</failure>';
        lf ]