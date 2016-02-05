running
runCase: aTestCase
  | error stack  |
  self
    beginTestCase: aTestCase
    runBlock: [ [ [ aTestCase runCase ]
      on: Halt , Error, TestFailure
      do: [ :err |
        error := err.
        aTestCase shouldPass ifTrue: [self serializeError: error of: aTestCase].
        stack := self stackTraceString: err of: aTestCase ]]
      on: (Smalltalk at: #TestSkip ifAbsent: []) do: [ :err | "nothing to do..." ] ].

  (error notNil or: [aTestCase shouldPass not])  ifTrue: [
    (error isKindOf: TestFailure)
      ifTrue: [ self writeFailure: error stack: stack ]
      ifFalse: [
		aTestCase shouldPass
			ifTrue: [ self writeError: error stack: stack ]
			ifFalse: [ error isNil ifTrue: [self writeUnexpectedPassFailure ]]]].

  self endTestCase