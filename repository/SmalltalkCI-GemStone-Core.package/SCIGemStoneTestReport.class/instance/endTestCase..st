private
endTestCase: anError
	anError ifNotNil: [
		(anError isKindOf: TestFailure)
			ifTrue: [ progressFile nextPut: $F ]
			ifFalse: [ progressFile nextPut: $E ] ].
      self stream
        tab;
        nextPutAll: '</testcase>';
        lf
