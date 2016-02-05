running
runCase: aTestCase
  | error stack |
  self
    beginTestCase: aTestCase
    runBlock: [ 
      [ aTestCase runCase ]
        on: Halt , Error , TestFailure
        do: [ :err | 
          error := err.
          stack := self stackTraceString: err of: aTestCase ] ].
  (error notNil or: [ aTestCase shouldPass not ])
    ifTrue: [ 
      (error isKindOf: TestFailure)
        ifTrue: [ self writeFailure: error stack: stack ]
        ifFalse: [ 
          aTestCase shouldPass
            ifTrue: [ self writeError: error stack: stack ]
            ifFalse: [ 
              error isNil
                ifTrue: [ self writeUnexpectedPassFailure ] ] ] ].
  self endTestCase