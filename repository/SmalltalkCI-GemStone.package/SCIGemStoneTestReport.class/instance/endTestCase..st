private
endTestCase: anError
  self produceXMLLog
    ifTrue: [
	anError ifNotNil: [
		(anError isKindOf: TestFailure)
			ifTrue: [ progressFile nextPut: $F ]
			ifFalse: [ progressFile nextPut: $E ] ].
      self stream
        tab;
        nextPutAll: '</testcase>';
        lf ]
    ifFalse: [ 
      progressFile
        nextPutAll: 'finished';
        cr ]