private
writeUnexpectedPassFailure
  suiteFailures := suiteFailures + 1.
  self produceXMLLog
    ifTrue: [ 
      stream
        tab;
        tab;
        nextPutAll:
            '<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>';
        lf ]
    ifFalse: [ 
      progressFile
        nextPutAll: 'Test passed unexpectedly';
        cr ]