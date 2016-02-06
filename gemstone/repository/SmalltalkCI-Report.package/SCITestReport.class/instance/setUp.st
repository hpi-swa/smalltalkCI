running
setUp
  progressFile := Transcript.
  self produceXMLLog
    ifTrue: [ 
      | xmlFilePath |
      xmlFilePath := (System gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
        ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , '/' , suite name , '.xml' ]
        ifNil: [ suite name , '.xml' ].
      stream := BinaryOrTextFile openWrite: xmlFilePath.
      stream
        nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>';
        lf.
      stream
        nextPutAll: '<testsuite name="';
        nextPutAll: (self encode: suite name);
        nextPutAll: '" tests="';
        print: suite tests size;
        nextPutAll: '">'.
      suitePosition := stream position - 1.	"Now this is ugly. We want to update the time and the number of failures and errors, but still at the same time stream a valid XML. So remember this position and add some whitespace, that we can fill later."
      stream
        nextPutAll: (String new: 100 withAll: $ );
        lf ].
  progressFile
    cr;
    nextPutAll: 'running suite: ';
    nextPutAll: suite name;
    nextPutAll: ' with: ';
    nextPutAll: suite tests size printString , ' tests';
    cr.
  suite resources
    do: [ :each | 
      each isAvailable
        ifFalse: [ each signalInitializationError ] ]