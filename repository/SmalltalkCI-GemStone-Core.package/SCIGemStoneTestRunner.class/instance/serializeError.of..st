private
serializeError: error of: aTestCase
  SmalltalkCI platformClass isTravisBuild
    ifFalse: [ 
      "only snap off continuation if doing a local build where developer can access continuations"
      (Smalltalk at: #'DebuggerLogEntry')
        createContinuationLabeled: self suiteName , ': ' , aTestCase printString.
      SmalltalkCI platformClass
        commitTransaction: 'attempting to log test case defect continuation' ]