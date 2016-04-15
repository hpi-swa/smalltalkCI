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
          aTestCase shouldPass
            ifTrue: [ self serializeError: error of: aTestCase ].
          stack := self stackTraceString: err of: aTestCase ] ].
  (error notNil or: [ aTestCase shouldPass not ])
    ifTrue: [ 
      (error isKindOf: TestFailure)
        ifTrue: [ 
          aTestCase shouldPass
            ifTrue: [ 
              self writeFailure: error stack: stack.
              testCaseFailures add: aTestCase ]
            ifFalse: [ 
              "expected failure"
               ] ]
        ifFalse: [ 
          aTestCase shouldPass
            ifTrue: [ 
              self writeError: error stack: stack.
              testCaseErrors add: aTestCase ]
            ifFalse: [ 
              error isNil
                ifTrue: [ 
                  self recordUnexpectedPassFor: aTestCase.
                  self writeUnexpectedPassFailure.
                  testCaseUnexpectedPasses add: aTestCase ] ] ] ].
  self endTestCase: error