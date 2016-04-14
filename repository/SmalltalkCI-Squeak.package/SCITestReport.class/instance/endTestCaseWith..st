private
endTestCaseWith: anError
	| logString |
	self
		writeTab;
		write: '</testcase>';
		writeLf.
	logString := '.'.
	anError ifNotNil: [
		(anError isKindOf: TestFailure)
			ifTrue: [ logString := 'F' ]
			ifFalse: [ logString := 'E' ] ].
	self log: logString